module Teams
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
      fulfillment_for(user).fulfill
      user.team = self
      user.save!
    end

    def remove_user(user)
      fulfillment_for(user).remove
      user.team = nil
      user.save!
    end

    def has_users_remaining?
      users.count < max_users
    end

    private

    def fulfillment_for(user)
      SubscriptionFulfillment.new(user, subscription.plan)
    end
  end
end
