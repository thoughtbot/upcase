class IndividualPlan < ActiveRecord::Base
  PRIME_BASIC_SKU = 'prime-basic'

  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :purchases, as: :purchaseable
  has_many :subscriptions, as: :plan

  validates :description, presence: true
  validates :individual_price, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanWithCountableSubscriptions
  include PlanForPublicListing

  def self.active
    where active: true
  end

  def self.default
    active.featured.ordered.first
  end

  def self.downgraded
    where(sku: PRIME_BASIC_SKU).first
  end

  def subscription_count
    subscriptions.active.paid.count
  end

  def projected_monthly_revenue
    subscription_count * individual_price
  end

  def purchase_for(user)
    purchases.paid.where(user_id: user).first
  end

  def starts_on(purchase_date)
    purchase_date
  end

  def ends_on(purchase_date)
    purchase_date
  end

  def subscription?
    true
  end

  def subscription_interval
    stripe_plan.interval
  end

  def offering_type
    'subscription'
  end

  def fulfillment_method
    'subscription'
  end

  def alternates
    []
  end

  def fulfilled_with_github?
    false
  end

  def announcement
    @announcement ||= announcements.current
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end
end
