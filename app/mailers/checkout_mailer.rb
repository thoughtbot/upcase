class CheckoutMailer < BaseMailer
  def receipt(checkout)
    @checkout = checkout

    mail(
      to: @checkout.user_email,
      subject: "Your receipt for #{@checkout.plan_name}"
    )
  end
end
