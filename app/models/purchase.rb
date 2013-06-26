require 'digest/md5'

class Purchase < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  PAYMENT_METHODS = %w(stripe paypal free)

  belongs_to :user
  belongs_to :purchaseable, polymorphic: true
  belongs_to :coupon
  serialize :github_usernames

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
  validates :user_id, presence: true, if: :subscription?

  before_validation :generate_lookup, on: :create
  before_validation :populate_billing_email, on: :create

  before_create :create_and_charge_customer, if: :stripe?
  before_create :setup_paypal_payment, if: :paypal?
  before_create :set_as_paid, if: :free?

  after_save :fulfill, if: :being_paid?
  after_save :send_receipt, if: :being_paid?
  after_save :update_user_stripe_customer_id, if: "being_paid? && stripe?"
  after_save :save_info_to_user, if: :user

  delegate :name, :sku, to: :purchaseable, prefix: :purchaseable, allow_nil: true
  delegate :fulfilled_with_github?, :subscription?, to: :purchaseable

  def self.from_month(date)
    where(
      ["created_at >= ? AND created_at <= ?",
        date.beginning_of_month,
        date.end_of_month
      ]
    )
  end

  def self.last_30_days
    last_thirty = (0..30).to_a.collect do |day|
      Purchase.paid.where(
        "created_at >= ? and created_at <= ?", 
        day.days.ago.beginning_of_day, 
        day.days.ago.end_of_day
      ).all.sum(&:price) 
    end
    last_thirty.reverse
  end

  def self.within_range(start_time, end_time)
    paid.where("created_at >= ? and created_at <= ?", start_time, end_time)
  end

  def self.total_sales_within_range(start_time, end_time)
    within_range(start_time, end_time).all.sum(&:price)
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
    where("stripe_customer_id is not null")
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
    if price.zero? && !subscription?
      "free"
    else
      read_attribute :payment_method
    end
  end

  def defaults_from_user(purchaser)
    if purchaser
      attributes_from_user.each do |attr|
        self.send(:"#{attr}=", purchaser.send(:"#{attr}"))
      end

      if github_username_needed? && purchaser.github_username.present?
        self.github_usernames = [purchaser.github_username]
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

  def refund
    if paid?
      if stripe?
        stripe_refund
      elsif paypal?
        paypal_refund
      end
      set_as_unpaid!

      if fulfilled_with_github?
        GithubFulfillment.new(self).remove
      end
      MailchimpFulfillment.new(self).remove
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

  def starts_on
    purchaseable.starts_on(created_at.to_date)
  end

  def ends_on
    purchaseable.ends_on(created_at.to_date)
  end

  def active?
    (starts_on..ends_on).cover?(Time.zone.today)
  end

  private

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def attributes_from_user
    %w(name email organization address1 address2 city state zip_code country)
  end

  def github_username_needed?
    fulfilled_with_github? || subscription?
  end

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
      elsif stripe_coupon_id.present?
        subscription_coupon = SubscriptionCoupon.new(stripe_coupon_id)
        subscription_coupon.apply(full_price)
      else
        full_price
      end
    end
  end

  def create_and_charge_customer
    begin
      ensure_stripe_customer_exists

      if subscription?
        create_stripe_subscription
      else
        charge_stripe_customer
      end

      set_as_paid
    rescue Stripe::StripeError => e
      errors[:base] << "There was a problem processing your credit card, #{e.message.downcase}"
      false
    end
  end

  def ensure_stripe_customer_exists
    if stripe_customer_id.blank?
      new_stripe_customer = Stripe::Customer.create(
        card: stripe_token,
        description: email,
        email: email
      )
      self.stripe_customer_id = new_stripe_customer.id
    end
  end

  def charge_stripe_customer
    charge = Stripe::Charge.create(
      amount: price_in_pennies,
      currency: "usd",
      customer: stripe_customer_id,
      description: purchaseable_name
    )
    self.payment_transaction_id = charge.id
  end

  def create_stripe_subscription
    if stripe_coupon_id.present?
      stripe_customer.update_subscription(
        plan: purchaseable_sku,
        coupon: stripe_coupon_id
      )
    else
      stripe_customer.update_subscription(plan: purchaseable_sku)
    end
  end

  def update_user_stripe_customer_id
    user.update_column(:stripe_customer_id, self.stripe_customer_id) if user
  end

  def fulfill
    if fulfilled_with_github?
      GithubFulfillment.new(self).fulfill
    end
    SubscriptionFulfillment.new(self).fulfill
    MailchimpFulfillment.new(self).fulfill
  end

  def generate_lookup
    key = "#{email}#{purchaseable_name}#{Time.zone.now}\n"
    self.lookup = Digest::MD5.hexdigest(key).downcase
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
    save_github_username_to_user
    save_organization_to_user
    save_address_to_user
  end

  def save_github_username_to_user
    if github_usernames.present? && user.github_username.blank?
      user.update_column(:github_username, github_usernames.first)
    end
  end

  def save_organization_to_user
    if organization.present?
      user.update_column(:organization, organization)
    end
  end

  def save_address_to_user
    if address1.present?
      user.update_column(:address1, address1)
      user.update_column(:address2, address2)
      user.update_column(:city, city)
      user.update_column(:state, state)
      user.update_column(:zip_code, zip_code)
      user.update_column(:country, country)
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
  end

  def populate_billing_email
    if billing_email.blank?
      self.billing_email = email
    end
  end
end
