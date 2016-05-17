class Checkout < ActiveRecord::Base
  COMMON_ATTRIBUTES = %i(
    address1
    address2
    city
    country
    email
    github_username
    name
    organization
    password
    state
    utm_source
    zip_code
  )

  belongs_to :plan
  belongs_to :user

  validates :user, presence: true

  delegate :includes_team?, :name, :sku, :terms, to: :plan, prefix: true
  delegate :email, to: :user, prefix: true

  attr_accessor \
    :stripe_customer_id,
    :stripe_subscription_id,
    :stripe_token,
    *COMMON_ATTRIBUTES

  def fulfill
    transaction do
      if find_or_create_valid_user
        create_subscriptions
      end
    end
  end

  def price
    plan.price_in_dollars * quantity
  end

  def quantity
    plan.minimum_quantity
  end

  def needs_github_username?
    user.nil? || issue_with_github_username?
  end

  def coupon
    @coupon ||= Coupon.new(stripe_coupon_id)
  end

  def has_invalid_coupon?
    stripe_coupon_id.present? && !coupon.valid?
  end

  def signing_up_with_username_and_password?
    [email, name, password, github_username].any?(&:present?)
  end

  private

  def issue_with_github_username?
    user.github_username.blank? || user.errors.include?(:github_username)
  end

  def create_subscriptions
    if create_stripe_subscription && save
      self.stripe_subscription_id = stripe_subscription.id
      update_stripe_customer_id
      plan.fulfill(self, user)
      send_receipt
    end
  end

  def find_or_create_valid_user
    initialize_user

    if user.save
      true
    else
      copy_errors_to_user
      false
    end
  end

  def copy_errors_to_user
    if user.invalid?
      %i(email name password github_username).each do |attribute|
        errors[attribute] = user.errors[attribute]
      end
    end
  end

  def create_stripe_subscription
    stripe_subscription.create
  end

  def initialize_user
    self.user ||= User.new

    AttributesCopier.new(
      source: self,
      target: user,
      attributes: COMMON_ATTRIBUTES
    ).copy_present_attributes
  end

  def update_stripe_customer_id
    user.update(stripe_customer_id: stripe_customer_id)
  end

  def send_receipt
    SendCheckoutReceiptEmailJob.perform_later(id)
  end

  def stripe_subscription
    @stripe_subscription ||= StripeSubscription.new(self)
  end
end
