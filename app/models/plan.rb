class Plan < ActiveRecord::Base
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :purchases, as: :purchaseable

  validates :company_price, presence: true
  validates :description, presence: true
  validates :individual_price, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

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
