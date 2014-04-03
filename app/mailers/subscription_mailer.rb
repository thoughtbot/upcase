class SubscriptionMailer < BaseMailer
  def welcome_to_prime_from_mentor(user)
    @user = user
    @mentor = user.mentor

    mail(
      to: @user.email,
      bcc: @mentor.email,
      subject: "Welcome to Prime! I'm your new mentor",
      from: mentor_email(@mentor),
      reply_to: mentor_email(@mentor)
    )
  end

  def cancellation_survey(user)
    @user = user

    mail(
      to: user.email,
      subject: 'Suggestions for improving Prime'
    )
  end

  def subscription_receipt(email, amount, stripe_invoice_id)
    @amount = amount
    @stripe_invoice_id = stripe_invoice_id

    mail(
      to: email,
      subject: '[Learn] Your receipt and some tips'
    )
  end

  def upcoming_payment_notification(subscription)
    @subscription = subscription
    @user = subscription.user

    mail(
      to: @user.email,
      subject: '[Learn] thoughtbot is about to charge for your Learn Prime subscription'
    )
  end

  private

  def mentor_email(mentor)
    "#{mentor.name} <#{mentor.email}>"
  end
end
