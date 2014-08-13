# TeamPlan represents a subscription plan for an entire team.
class TeamPlan < ActiveRecord::Base
  has_many :checkouts, as: :subscribeable
  has_many :subscriptions, as: :plan
  has_many :teams

  validates :individual_price, presence: true
  validates :name, presence: true
  validates :sku, presence: true

  include PlanForPublicListing

  def subscription_interval
    'month'
  end

  def minimum_quantity
    3
  end

  def fulfill(checkout, user)
    user.create_purchased_subscription(plan: self)
    SubscriptionFulfillment.new(user, self).fulfill
    TeamFulfillment.new(checkout, user).fulfill
  end

  def after_checkout_url(controller, checkout)
    controller.edit_team_path
  end

  def included_in_plan?(plan)
    false
  end

  def has_feature?(feature)
    public_send("includes_#{feature}?")
  end
end
