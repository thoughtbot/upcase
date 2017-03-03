class SubscriptionsRestarter
  def initialize(subscription)
    @subscription = subscription
  end

  def self.restart_todays_paused_subscriptions
    Subscription.restarting_today.each do |subscription|
      new(subscription).restart
    end
  end

  def restart
    Subscription.transaction do
      subscription.update!(reactivated_on: Time.zone.now)

      Resubscription.new(
        user: subscription.user,
        plan: subscription.plan,
      ).fulfill

      PauseMailer.restarted(subscription).deliver_later
    end
  end

  protected

  attr_reader :subscription
end
