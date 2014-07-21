class IndividualPlan < ActiveRecord::Base
  PRIME_249_SKU = 'prime-249'
  PRIME_99_SKU = 'prime-99'
  PRIME_49_SKU = 'prime-49'
  PRIME_29_SKU = 'prime-29'

  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :checkouts, as: :subscribeable
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
    where(sku: PRIME_29_SKU).first
  end

  def self.popular
    where(sku: PRIME_99_SKU).first
  end

  def popular?
    self == self.class.popular
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
    user.create_purchased_subscription(plan: self)
    SubscriptionFulfillment.new(user, self).fulfill
  end

  def after_purchase_url(controller, purchase)
    controller.dashboard_path
  end

  def included_in_plan?(plan)
    false
  end

  def has_feature?(feature)
    public_send("includes_#{feature}?")
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end
end
