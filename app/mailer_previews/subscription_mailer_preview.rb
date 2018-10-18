class SubscriptionMailerPreview < ActionMailer::Preview
  def upcoming_payment_notification
    subscription = Subscription.first.tap do |sub|
      sub.next_payment_amount = 5000
      sub.next_payment_on = 1.week.from_now
    end

    SubscriptionMailer.upcoming_payment_notification(subscription)
  end
end
