class User < ActiveRecord::Base
  include Clearance::User

  has_many :paid_purchases, -> { where paid: true }, class_name: 'Purchase'
  has_many :purchases
  has_many :completions
  has_many :notes, -> { order 'created_at DESC' }
  has_one :subscription
  belongs_to :mentor, class_name: 'User'
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'

  validates :name, presence: true

  delegate :email, to: :mentor, prefix: true
  delegate :name, to: :mentor, prefix: true, allow_nil: true

  def self.mentors
    where(available_to_mentor: true)
  end

  def self.find_or_sample_mentor(user_id)
    where(id: user_id).first || mentors.sample
  end

  def subscription_purchases
    paid_purchases.where(payment_method: 'subscription')
  end

  def paid_products
    paid_purchases.where("purchaseable_type != 'IndividualPlan'")
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  def external_auth?
    auth_provider.present?
  end

  def has_purchased?
    paid_purchases.present?
  end

  def inactive_subscription
    if subscription.present? && !subscription.active?
      subscription
    end
  end

  def has_logged_in_to_forum?
    OauthAccessToken.for_user(self).present?
  end

  def has_active_subscription?
    subscription.present? && subscription.active?
  end

  def subscribed_at
    subscription.try(:created_at)
  end

  def credit_card
    if stripe_customer
      stripe_customer['active_card']
    end
  end

  def assign_mentor(user)
    update_attribute(:mentor_id, user.id)
  end

  def has_subscription_with_mentor?
    subscription.try(:includes_mentor?)
  end

  def plan_name
    subscription.try(:plan).try(:name)
  end

  private

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  def password_optional?
    super || external_auth?
  end
end
