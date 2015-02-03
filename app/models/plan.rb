class Plan < ActiveRecord::Base
  PRIME_249_SKU = "prime-249"
  PROFESSIONAL_SKU = "professional"
  THE_WEEKLY_ITERATION_SKU = "the-weekly-iteration"

  has_many :checkouts
  has_many :subscriptions, as: :plan
  belongs_to :annual_plan, class_name: "Plan"

  validates :description, presence: true
  validates :price, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanForPublicListing

  def self.individual
    where includes_team: false
  end

  def self.team
    where includes_team: true
  end

  def self.active
    where active: true
  end

  def self.default
    individual.active.featured.ordered.first
  end

  def self.default_team
    team.active.featured.ordered.first
  end

  def self.basic
    where(sku: THE_WEEKLY_ITERATION_SKU).first
  end

  def self.popular
    where(sku: PROFESSIONAL_SKU).first
  end

  def popular?
    self == self.class.popular
  end

  def includes_exercises?
    sku != THE_WEEKLY_ITERATION_SKU
  end

  def subscription_interval
    stripe_plan.interval
  end

  def fulfill(checkout, user)
    user.create_subscription(
      plan: self,
      stripe_id: checkout.stripe_subscription_id
    )
    SubscriptionFulfillment.new(user, self).fulfill
    if includes_team?
      TeamFulfillment.new(checkout, user).fulfill
    end
  end

  def included_in_plan?(plan)
    false
  end

  def has_annual_plan?
    annual_plan.present?
  end

  def has_feature?(feature)
    public_send("includes_#{feature}?")
  end

  def annualized_payment
    12 * price
  end

  def discounted_annual_payment
    annual_plan.price
  end

  def annual_plan_sku
    annual_plan.sku
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end
end
