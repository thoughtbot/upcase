class PendingReactivationNotifier
  def self.notify
    pending_subscriptions = Subscription.restarting_in_two_days

    pending_subscriptions.each do |subscription|
      PauseMailer.pre_notification(subscription).deliver_later
    end
  end
end
