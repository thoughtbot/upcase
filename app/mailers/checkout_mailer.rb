class CheckoutMailer < BaseMailer
  def receipt(user_email, plan_id)
    @plan = Plan.find(plan_id)

    mail(
      to: user_email,
      subject: "Your receipt for #{@plan.name}"
    )
  end
end
