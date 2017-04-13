class SubscriptionMailerPreview < ActionMailer::Preview
  def subscription_receipt
    email = "subscriber@example.com"
    amount = 5000
    stripe_invoice_id = "INVOICE"

    SubscriptionMailer.subscription_receipt(email, amount, stripe_invoice_id)
  end

  def upcoming_payment_notification
    subscription = Subscription.first.tap do |subscription|
      subscription.next_payment_amount = 5000
      subscription.next_payment_on = 1.week.from_now
    end

    SubscriptionMailer.upcoming_payment_notification(subscription)
  end
end
