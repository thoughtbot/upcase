# TeamPlans represent a purchase of a subscription plan for an entire team.
#
# Currently, there is only one level of team plan.
class TeamPlan < ActiveRecord::Base
  has_many :subscriptions, as: :plan
  has_many :purchases, as: :purchaseable
  has_many :teams

  validates :sku, presence: true
  validates :name, presence: true

  def self.instance
    if last
      last
    else
      plan = new(sku: 'primeteam', name: 'Prime for Teams')
      plan.save!
      plan
    end
  end

  def subscription?
    true
  end

  def individual_price
    1099
  end

  def fulfillment_method
    'subscription'
  end

  def fulfilled_with_github?
    false
  end

  def subscription_interval
    'monthly'
  end

  def terms
    'No minimum subscription length. Cancel at any time.'
  end

  def includes_mentor?
    false
  end

  def includes_workshops?
    true
  end

  def announcement
    ''
  end
end
