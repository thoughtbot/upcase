class IndividualPlan < ActiveRecord::Base
  PRIME_BASIC_SKU = 'prime-basic'
  PRIME_BASIC_YEARLY_SKU = 'PRIMEBASICYEAR'
  PRIME_WORKSHOPS_SKU = 'prime'
  PRIME_WORKSHOPS_YEARLY_SKU = 'primeyear'
  PRIME_WITH_MENTORING_SKU = 'prime-mentor'

  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :purchases, as: :purchaseable
  has_many :subscriptions, as: :plan

  validates :description, presence: true
  validates :individual_price, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanWithCountableSubscriptions

  def self.prime_basic
    find_by(sku: PRIME_BASIC_SKU)
  end

  def self.prime_basic_yearly
    find_by(sku: PRIME_BASIC_YEARLY_SKU)
  end

  def self.prime_workshops
    find_by(sku: PRIME_WORKSHOPS_SKU)
  end

  def self.prime_workshops_yearly
    find_by(sku: PRIME_WORKSHOPS_YEARLY_SKU)
  end

  def self.prime_with_mentoring
    find_by(sku: PRIME_WITH_MENTORING_SKU)
  end

  def self.active
    where active: true
  end

  def self.featured
    where featured: true
  end

  def self.ordered
    order('individual_price desc')
  end

  def self.default
    active.featured.ordered.first
  end

  def self.downgraded
    prime_basic
  end

  def subscription_count
    subscriptions.active.paid.count
  end

  def projected_monthly_revenue
    subscription_count * individual_price
  end

  def to_param
    sku
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
