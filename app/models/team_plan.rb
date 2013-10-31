# TeamPlans represent a purchase of a subscription plan for an entire team.
#
# Currently, there is only one level of team plan.
class TeamPlan < ActiveRecord::Base
  has_many :subscriptions, as: :plan
  has_many :purchases, as: :purchaseable
  has_many :teams

  validates :sku, presence: true
  validates :name, presence: true
  validates :individual_price, presence: true

  include PlanWithCountableSubscriptions
  include PlanForPublicListing

  def self.instance
    if last
      last
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
end
