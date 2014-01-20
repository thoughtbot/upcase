# TeamPlans represent a purchase of a subscription plan for an entire team.
class TeamPlan < ActiveRecord::Base
  has_many :purchases, as: :purchaseable
  has_many :subscriptions, as: :plan
  has_many :teams

  validates :individual_price, presence: true
  validates :name, presence: true
  validates :sku, presence: true

  include PlanForPublicListing
  include PlanWithCountableSubscriptions

  def self.instance
    if first
      first
    else
      create!(sku: 'primeteam', name: 'Prime for Teams', individual_price: 0)
    end
  end

  def projected_monthly_revenue
    teams.count * individual_price
  end

  def subscription?
    true
  end

  def fulfillment_method
    'subscription'
  end

  def fulfilled_with_github?
    false
  end

  def subscription_interval
    'month'
  end

  def announcement
    ''
  end

  def minimum_quantity
    5
  end

  def fulfill(purchase, user)
    SubscriptionFulfillment.new(purchase, user).fulfill
    TeamFulfillment.new(purchase, user).fulfill
  end

  def after_purchase_url(controller, purchase)
    controller.edit_team_path
  end
end
