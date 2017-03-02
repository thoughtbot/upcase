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
    Resubscription.new(
      user: subscription.user,
      plan: subscription.plan,
    ).fulfill

    PauseMailer.restarted(subscription).deliver_later
  end

  protected

  attr_reader :subscription
end
