class SubscriptionMailer < BaseMailer
  def subscription_receipt(email, amount, stripe_invoice_id)
    @amount = amount
    @stripe_invoice_id = stripe_invoice_id

    mail(
      to: email,
      subject: t("mailers.subscription.subscription_receipt.subject"),
    )
  end

  def upcoming_payment_notification(subscription)
    @subscription = subscription
    @user = subscription.user

    mail(
      to: @user.email,
      subject:
        t("mailers.subscription.upcoming_payment_notification.subject"),
    )
  end
end
