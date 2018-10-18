class SubscriptionMailer < BaseMailer
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
