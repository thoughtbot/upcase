# A Team represents a company that has purchased a TeamPlan subscription.
#
# Because purchases of TeamPlans happens rarely, Teams are created manually,
# and not through the UI.
class Team < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :team_plan

  has_many :users, dependent: :nullify

  validates :name, presence: true

  def add_user(user)
    SubscriptionFulfillment.new(subscription.purchase, user).fulfill
    user.team = self
    user.save!
  end

  def remove_user(user)
    SubscriptionFulfillment.new(subscription.purchase, user).remove
    user.team = nil
    user.save!
  end
end
