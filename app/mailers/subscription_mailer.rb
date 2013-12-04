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

  def subscription_receipt(email, plan_name, amount, stripe_invoice_id)
    @plan_name = plan_name
    @amount = amount
    @stripe_invoice_id = stripe_invoice_id

    mail(
      to: email,
      subject: "[Learn] Your #{plan_name} receipt and some tips"
    )
  end

  private

  def mentor_email(mentor)
    "#{mentor.name} <#{mentor.email}>"
  end
end
