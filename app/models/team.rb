# A Team represents a company that has a TeamPlan subscription.
class Team < ApplicationRecord
  belongs_to :subscription

  has_many :users, dependent: :nullify
  has_many :invitations

  validates :name, presence: true

  delegate :owner?, :plan, to: :subscription

  def owner
    subscription.user
  end

  def add_user(user)
    user.deactivate_personal_subscription
    user.team = self
    user.save!
    update_billing_quantity
    fulfillment_for(user).fulfill
  end

  def remove_user(user)
    user.team = nil
    user.save!
    update_billing_quantity
    fulfillment_for(user).remove
  end

  def below_minimum_users?
    users_count < plan.minimum_quantity
  end

  def users_count
    users.count
  end

  def annualized_savings
    users_count * plan.annualized_savings
  end

  private

  def update_billing_quantity
    subscription.change_quantity(billing_quantity)
  end

  def billing_quantity
    [users_count, plan.minimum_quantity].max
  end

  def fulfillment_for(user)
    SubscriptionFulfillment.new(user, plan)
  end
end
