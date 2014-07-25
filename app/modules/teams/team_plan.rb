module Teams
  # TeamPlan represents a purchase of a subscription plan for an entire team.
  class TeamPlan < ActiveRecord::Base
    has_many :checkouts, as: :subscribeable
    has_many :subscriptions, as: :plan
    has_many :teams

    validates :individual_price, presence: true
    validates :name, presence: true
    validates :sku, presence: true

    include PlanForPublicListing

    def self.instance
      if first
        first
      else
        create!(
          sku: 'primeteam',
          name: I18n.t("shared.team_plan_name"),
          individual_price: 0,
        )
      end
    end

    def subscription_interval
      'month'
    end

    def minimum_quantity
      3
    end

    def fulfill(purchase, user)
      user.create_purchased_subscription(plan: self)
      SubscriptionFulfillment.new(user, self).fulfill
      TeamFulfillment.new(purchase, user).fulfill
    end

    def after_checkout_url(controller, checkout)
      controller.edit_teams_team_path
    end

    def included_in_plan?(plan)
      false
    end

    def has_feature?(feature)
      public_send("includes_#{feature}?")
    end
  end
end
