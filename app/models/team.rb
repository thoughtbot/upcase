# A Team represents a company that has purchased a TeamPlan subscription.
#
# Because purchases of TeamPlans happens rarely, Teams are created manually,
# and not through the UI.
class Team < ActiveRecord::Base
  belongs_to :team_plan

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :name, presence: true
end
