# A Team represents a company that has a TeamPlan subscription.
class Team < ActiveRecord::Base
  belongs_to :subscription

  has_many :users, dependent: :nullify
  has_many :invitations

  validates :name, presence: true

  delegate :owner?, :plan, to: :subscription

  def add_user(user)
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
    users_count < IndividualPlan::MINIMUM_TEAM_SIZE
  end

  private

  def update_billing_quantity
    subscription.change_quantity(billing_quantity)
  end

  def billing_quantity
    [users_count, IndividualPlan::MINIMUM_TEAM_SIZE].max
  end

  def fulfillment_for(user)
    SubscriptionFulfillment.new(user, plan)
  end

  def users_count
    users.count
  end
end
