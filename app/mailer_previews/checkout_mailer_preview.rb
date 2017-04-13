class CheckoutMailerPreview < ActionMailer::Preview
  def receipt
    user = User.first
    plan = Plan.first
    checkout = Checkout.first_or_initialize(user: user, plan: plan)

    CheckoutMailer.receipt(checkout)
  end
end
