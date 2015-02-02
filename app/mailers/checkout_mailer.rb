class CheckoutMailer < BaseMailer
  def receipt(checkout)
    @plan = checkout.plan

    mail(
      to: checkout.user_email,
      subject: "Your receipt for #{@plan.name}"
    )
  end
end
