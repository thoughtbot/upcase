class IndividualPlan < ActiveRecord::Base
  PRIME_BASIC_SKU = 'prime-basic'
  PRIME_249_SKU = 'prime-249'
  PRIME_99_SKU = 'prime-99'
  PRIME_49_SKU = 'prime-49'
  PRIME_29_SKU = 'prime-29'

  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :purchases, as: :purchaseable
  has_many :subscriptions, as: :plan

  validates :description, presence: true
  validates :individual_price, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanForPublicListing

  def self.active
    where active: true
  end

  def self.default
    active.featured.ordered.first
  end

  def self.basic
    where(sku: PRIME_BASIC_SKU).first
  end

  def self.popular
    where(sku: PRIME_99_SKU).first
  end

  def popular?
    self == self.class.popular
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

  def fulfilled_with_github?
    false
  end

  def announcement
    @announcement ||= announcements.current
  end

  def fulfill(purchase, user)
    SubscriptionFulfillment.new(purchase, user).fulfill
  end

  def after_purchase_url(controller, purchase)
    controller.dashboard_path
  end

  def included_in_plan?(plan)
    false
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end
end
