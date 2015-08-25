class SignupsController < ApplicationController
  def create
    stripe_customer = create_stripe_customer
    fulfill(stripe_customer.subscriptions.first.id)

    flash[:notice] = I18n.t("checkout.flashes.success")
    track_signup_via_segment
    track_signup_in_vanity
    redirect_to onboarding_policy.root_path
  rescue Stripe::CardError => error
    flash[:error] = error.message
    redirect_to new_payment_path
  end

  private

  def create_stripe_customer
    Stripe::Customer.create(
      source: params[:stripe_token],
      email: current_user.email,
      description: "Created using new checkout flow",
      plan: professional_plan.sku,
    )
  end

  def fulfill(stripe_subscription_id)
    professional_plan.fulfill(
      checkout_duck(stripe_subscription_id),
      current_user,
    )
  end

  def track_signup_via_segment
    flash[:purchase_amount] = professional_plan.price_in_dollars
  end

  def checkout_duck(stripe_subscription_id)
    OpenStruct.new(stripe_subscription_id: stripe_subscription_id)
  end

  def professional_plan
    Plan.popular
  end
end
