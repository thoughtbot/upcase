require 'digest/md5'

class Purchase < ActiveRecord::Base
  PAYMENT_METHODS = %w(stripe paypal subscription free)

  belongs_to :user
  belongs_to :purchaseable, polymorphic: true
  belongs_to :coupon
  serialize :github_usernames

  attr_accessor :stripe_token, :paypal_url, :password, :mentor_id

  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :lookup, presence: true
  validates :name, presence: true
  validates :password, presence: true, if: :password_required?
  validates :payment_method, inclusion: { in: PAYMENT_METHODS }, presence: true
  validates :purchaseable_id, presence: true
  validates :purchaseable_type, presence: true
  validates :quantity, presence: true
  validates :user_id, presence: true, if: :subscription?
  validates :variant, presence: true

  before_validation :create_user, if: :password_required?
  before_validation :generate_lookup, on: :create
  before_validation :set_free_payment_method, on: :create

  before_create :place_payment

  after_save :save_info_to_user, if: :user
  after_save :fulfill, if: :being_paid?
  after_save :send_receipt, if: :being_paid?
  after_save :update_user_payment_info, if: :being_paid?

  delegate :name, :sku,
    to: :purchaseable,
    prefix: :purchaseable,
    allow_nil: true
  delegate :fulfilled_with_github?, :subscription?, :terms, :fulfillment_method,
    to: :purchaseable

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

  def self.with_stripe_customer_id
    where("stripe_customer_id is not null")
  end

  def self.by_email(email)
    where(email: email)
  end

  def price(coupon=CouponFactory.for_purchase(self))
    paid_price || PurchasePriceCalculator.new(self, coupon).calculate
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
    payment_method == 'stripe'
  end

  def paypal?
    payment_method == 'paypal'
  end

  def free?
    price.zero?
  end

  def purchasing_as_subscriber?
    payment_method == 'subscription'
  end

  def complete_payment(params)
    payment.complete(params)
    save!
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

  def payment
    @payment ||= Payments::Factory.new(payment_method).new(self)
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

  def set_free_payment_method
    if free? && !subscription? && !purchasing_as_subscriber?
      self.payment_method = 'free'
    end
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def being_paid?
    paid? && paid_was == false
  end

  def place_payment
    payment.place
  end

  def update_user_payment_info
    if user
      payment.update_user(user)
    end
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

  def save_info_to_user
    PurchaseInfoCopier.new(self, user).copy_info_to_user
  end

  def send_receipt
    unless purchasing_as_subscriber?
      SendPurchaseReceiptEmailJob.enqueue(id)
    end
  end
end
