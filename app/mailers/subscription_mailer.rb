class SubscriptionMailer < BaseMailer
  def welcome_to_upcase_from_mentor(user)
    @user = user
    @mentor = user.mentor

    mail(
      to: @user.email,
      bcc: @mentor.email,
      subject: t("mailers.subscription.welcome_from_mentor.subject"),
      from: mentor_email(@mentor),
      reply_to: mentor_email(@mentor)
    )
  end

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

  private

  def mentor_email(mentor)
    "#{mentor.name} <#{mentor.email}>"
  end
end
