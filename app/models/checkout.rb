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
    zip_code
  )

  belongs_to :plan
  belongs_to :user

  validates :github_username, :user, presence: true

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

  def needs_github?
    user.nil? ||
      user.github_username.blank? ||
      errors[:github_username].present?
  end

  def coupon
    @coupon ||= Coupon.new(stripe_coupon_id)
  end

  private

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
    user.save
    validate_checkout_user
    user.valid?
  end

  def validate_checkout_user
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
      target: user,
      source: self,
      attributes: COMMON_ATTRIBUTES
    ).copy_present_attributes
  end

  def update_stripe_customer_id
    user.update(stripe_customer_id: stripe_customer_id)
  end

  def send_receipt
    SendCheckoutReceiptEmailJob.enqueue(id)
  end

  def stripe_subscription
    @stripe_subscription ||= StripeSubscription.new(self)
  end
end
