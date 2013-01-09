require 'digest/md5'

class Purchase < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  PAYMENT_METHODS = %w(stripe paypal free)
  API_SLEEP_TIME = 0.2

  belongs_to :user
  belongs_to :purchaseable, polymorphic: true
  belongs_to :coupon
  serialize :readers

  attr_accessor :stripe_token, :paypal_url

  validates :variant, presence: true
  validates :purchaseable_id, presence: true
  validates :purchaseable_type, presence: true
  validates :name, presence: true
  validates :lookup, presence: true
  validates :payment_method, presence: true
  validates :billing_email, presence: true
  validate :payment_method_must_match_price
  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  before_validation :generate_lookup, on: :create
  before_validation :populate_billing_email, on: :create

  before_create :create_and_charge_customer, if: :stripe?
  before_create :setup_paypal_payment, if: :paypal?
  before_create :set_as_paid, if: :free?

  after_save :fulfill, if: :being_paid?
  after_save :send_receipt, if: :being_paid?
  after_save :update_user_stripe_customer, if: "being_paid? && stripe?"
  after_save :save_info_to_user, if: :user

  delegate :name, to: :purchaseable, prefix: :purchaseable, allow_nil: true

  def self.from_month(date)
    where(["created_at >= ? AND created_at <= ?", date.beginning_of_month, date.end_of_month])
  end

  def self.last_30_days
    (0..30).to_a.collect { |day| Purchase.paid.where("created_at >= ? and created_at <= ?", day.days.ago.beginning_of_day, day.days.ago.end_of_day).all.sum(&:price) }.reverse
  end

  def self.from_period(start_time, end_time)
    paid.where("created_at >= ? and created_at <= ?", start_time, end_time).all.sum(&:price)
  end

  def self.for_purchaseable(purchaseable)
    where(purchaseable_id: purchaseable.id, purchaseable_type: purchaseable.class.name)
  end

  def self.paid
    where(paid: true)
  end

  def self.host
    if defined?(@@host)
      @@host
    else
      ActionMailer::Base.default_url_options[:host]
    end
  end

  def self.host=(host)
    @@host = host
  end

  def self.stripe
    where("stripe_customer is not null")
  end

  def self.by_email(email)
    where(email: email)
  end

  def price
    paid_price || calculated_price
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  def to_param
    lookup
  end

  def stripe?
    payment_method == "stripe"
  end

  def paypal?
    payment_method == "paypal"
  end

  def free?
    payment_method == "free"
  end

  def payment_method
    if price.zero?
      "free"
    else
      read_attribute :payment_method
    end
  end

  def defaults_from_user(purchaser)
    if purchaser
      self.name = purchaser.name
      self.email = purchaser.email
      if fulfilled_with_github? && purchaser.github_username.present?
        self.readers = [purchaser.github_username]
      end
    end
  end

  def complete_paypal_payment!(token, payer_id)
    response = paypal_request.checkout!(
      token,
      payer_id,
      paypal_payment_request
    )

    self.payment_transaction_id = response.payment_info.first.transaction_id
    set_as_paid
    save!
  end

  def success_url
    if paypal?
      paypal_url
    else
      purchase_path(self, host: self.class.host)
    end
  end

  def fulfilled_with_github?
    purchaseable.fulfillment_method == "github"
  end

  def refund
    if paid?
      if stripe?
        stripe_refund
      elsif paypal?
        paypal_refund
      end
      set_as_unpaid!
      remove_readers_from_github
    end
  end

  def remove_readers_from_github
    if readers && readers.any?
      readers.each do |username|
        RemoveGithubTeamMemberJob.enqueue(purchaseable.github_team, username)
        sleep API_SLEEP_TIME
      end
    end
  end

  def stripe_refund
    charge = Stripe::Charge.retrieve(payment_transaction_id)
    if charge && !charge.refunded
      charge.refund(amount: price_in_pennies)
    end
  end

  def paypal_refund
    paypal_request.refund!(payment_transaction_id)
  end

  private

  def being_paid?
    paid? && paid_was == false
  end

  def calculated_price
    if variant.blank?
      0
    else
      full_price = purchaseable.send(:"#{variant}_price")
      if coupon
        coupon.apply(full_price)
      else
        full_price
      end
    end
  end

  def create_and_charge_customer
    begin
      if stripe_customer.blank?
        customer = Stripe::Customer.create(
          card: stripe_token,
          description: email,
          email: email
        )
        self.stripe_customer = customer.id
      end

      charge = Stripe::Charge.create(
        amount: price_in_pennies,
        currency: "usd",
        customer: stripe_customer,
        description: purchaseable_name
      )
      self.payment_transaction_id = charge.id

      set_as_paid
    rescue Stripe::StripeError => e
      errors[:base] << "There was a problem processing your credit card, #{e.message.downcase}"
      false
    end
  end

  def update_user_stripe_customer
    user.update_column(:stripe_customer, self.stripe_customer) if user
  end

  def fulfill
    if fulfilled_with_github?
      fulfill_with_github
    end
  end

  def fulfill_with_github
    github_usernames.each do |username|
      AddGithubTeamMemberJob.enqueue(purchaseable.github_team, username, id)
      sleep API_SLEEP_TIME
    end
  end

  def github_usernames
    readers.map(&:strip).reject(&:blank?).compact
  end

  def generate_lookup
    self.lookup = Digest::MD5.hexdigest("#{email}#{purchaseable_name}#{Time.now}\n").downcase
  end

  def payment_method_must_match_price
    if free? && price > 0
      errors.add(:payment_method, 'cannot be free')
    end
  end

  def paypal_payment_request
    Paypal::Payment::Request.new(
      currency_code: :USD,
      amount: price,
      description: purchaseable_name,
      items: [{ amount: price,
                   description: purchaseable_name }]
    )
  end

  def paypal_request
    Paypal::Express::Request.new(
      username: PAYPAL_USERNAME,
      password: PAYPAL_PASSWORD,
      signature: PAYPAL_SIGNATURE
    )
  end

  def price_in_pennies
    (price * 100).to_i
  end

  def save_info_to_user
    if readers.present? && user.github_username.blank?
      user.update_column(:github_username, readers.first)
    end
  end

  def set_as_paid
    self.paid = true
    self.paid_price = price
    coupon.try(:applied)
  end

  def set_as_unpaid!
    self.paid = false
    save!
  end

  def setup_paypal_payment
    response = paypal_request.setup(
      paypal_payment_request,
      paypal_purchase_url(self, host: self.class.host),
      products_url(host: self.class.host)
    )
    self.paid = false
    self.paypal_url = response.redirect_uri
  end

  def send_receipt
    SendPurchaseReceiptEmailJob.enqueue(id)
    purchaseable.send_registration_emails(self)
  end

  def populate_billing_email
    if billing_email.blank?
      self.billing_email = email
    end
  end
end
