class SubscriptionPaymentComingUpNotifier
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def process
    @subscriptions.each do |subscription|
      SubscriptionMailer.upcoming_payment_notification(subscription).deliver_now
    end
  end
end
