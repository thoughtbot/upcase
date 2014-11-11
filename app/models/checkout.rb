class Checkout < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user

  validates :email, :github_username, :quantity, :user_id, presence: true

  delegate :name, :sku, to: :plan, prefix: true
  delegate :includes_team?, :terms, to: :plan
  delegate :email, to: :user, prefix: true
  delegate :first_name, to: :user, prefix: true
  delegate :github_username, to: :user, prefix: true
  delegate :last_name, to: :user, prefix: true
  delegate :organization, to: :user, prefix: true

  attr_accessor \
    :address1,
    :address2,
    :city,
    :country,
    :email,
    :github_username,
    :name,
    :organization,
    :password,
    :state,
    :stripe_customer_id,
    :stripe_subscription_id,
    :stripe_token,
    :zip_code

  def fulfill
    transaction do
      if user.present? || create_valid_user
        create_subscriptions
      end
    end
  end

  def price
    plan.individual_price * quantity
  end

  private

  def create_subscriptions
    if create_stripe_subscription && save
      self.stripe_subscription_id = stripe_subscription.id
      save_info_to_user
      plan.fulfill(self, user)
      send_receipt
    end
  end

  def create_valid_user
    self.user = User.create(
      name: name,
      email: email,
      password: password,
      github_username: github_username
    )
    copy_user_validations
    user.valid?
  end

  def copy_user_validations
    if user.invalid?
      %i(email name password github_username).each do |attribute|
        errors[attribute] = user.errors[attribute]
      end
    end
  end

  def create_stripe_subscription
    stripe_subscription.create
  end

  def save_info_to_user
    CheckoutInfoCopier.new(self, user).copy_info_to_user
    stripe_subscription.update_user(user)
  end

  def send_receipt
    SendCheckoutReceiptEmailJob.enqueue(id)
  end

  def stripe_subscription
    @stripe_subscription ||= StripeSubscription.new(self)
  end
end
