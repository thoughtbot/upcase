require 'digest/md5'

class Purchase < ActiveRecord::Base
  PAYMENT_METHODS = %w(stripe paypal free)

  belongs_to :user
  belongs_to :purchaseable, polymorphic: true
  belongs_to :coupon
  serialize :github_usernames

  attr_accessor :stripe_token, :paypal_url, :password, :mentor_id

  validates :variant, presence: true
  validates :purchaseable_id, presence: true
  validates :purchaseable_type, presence: true
  validates :name, presence: true
  validates :lookup, presence: true
  validates :payment_method, presence: true
  validate :payment_method_must_match_price
  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, presence: true, if: :password_required?
  validates :user_id, presence: true, if: :subscription?

  before_validation :create_user, if: :password_required?
  before_validation :generate_lookup, on: :create

  before_create :place_payment
  before_create :set_as_paid, if: :free?

  after_save :fulfill, if: :being_paid?
  after_save :send_receipt, if: :being_paid?
  after_save :update_user_payment_info, if: :being_paid?
  after_save :save_info_to_user, if: :user

  delegate :name,
    :sku,
    to: :purchaseable,
    prefix: :purchaseable,
    allow_nil: true
  delegate :fulfilled_with_github?,
    :subscription?,
    :terms,
    :fulfillment_method,
    to: :purchaseable

  def self.of_sections
    where(purchaseable_type: 'Section')
  end

  def self.from_month(date)
    where(
      ["created_at >= ? AND created_at <= ?",
        date.beginning_of_month,
        date.end_of_month
      ]
    )
  end

  def self.within_30_days
    where('created_at >= ?', 30.days.ago)
  end

  def self.date_of_last_workshop_purchase
    purchase = of_sections.order('created_at DESC').first
    if purchase
      purchase.created_at.to_date
    end
  end

  def self.within_range(start_time, end_time)
    paid.where("created_at >= ? and created_at <= ?", start_time, end_time)
  end

  def self.total_sales_within_range(start_time, end_time)
    within_range(start_time, end_time).to_a.sum(&:price)
  end

  def self.for_purchaseable(purchaseable)
    where(purchaseable_id: purchaseable.id, purchaseable_type: purchaseable.class.name)
  end

  def self.paid
    where(paid: true)
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

  def complete_payment(params)
    payment.complete(params)
    save!
  end

  def refund
    if paid?
      payment.refund
      set_as_unpaid!

      if fulfilled_with_github?
        GithubFulfillment.new(self).remove
      end
      MailchimpFulfillment.new(self).remove
    end
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

  def status
    if self.purchaseable.online? && self.ends_on.future?
      'in-progress'
    elsif self.ends_on.future?
      'registered'
    elsif self.ends_on.past?
      'complete'
    end
  end

  def set_as_paid
    self.paid = true
    self.paid_price = price
    coupon.try(:applied)
  end

  def set_as_unpaid
    self.paid = false
  end

  private

  def password_required?
    subscription? && user.blank?
  end

  def create_user
    if name.present? && email.present? && password.present?
      self.user = User.create(name: name, email: email, password: password)
      add_errors_from_user unless user.valid?
    end
  end

  def add_errors_from_user
    errors[:email] = user.errors[:email]
    errors[:name] = user.errors[:name]
    errors[:password] = user.errors[:password]
    errors
  end

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

  def place_payment
    payment.place
  end

  def update_user_payment_info
    if user
      payment.update_user(user)
    end
  end

  def payment
    @payment ||= Payments::Factory.new(payment_method).new(self)
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
      write_user_columns %w(organization)
    end
  end

  def save_address_to_user
    if address1.present?
      write_user_columns(%w(address1 address2 city state zip_code country))
    end
  end

  def write_user_columns(names)
    if user
      names.each { |name| user.update_column name, send(name) }
    end
  end

  def set_as_unpaid!
    set_as_unpaid
    save!
  end

  def send_receipt
    SendPurchaseReceiptEmailJob.enqueue(id)
  end
end
