class CheckoutsController < ApplicationController
  def new
    if current_user_has_active_subscription?
      redirect_to(
        edit_subscription_path,
        notice: t("checkout.flashes.already_subscribed")
      )
    else
      @checkout = build_checkout({})
    end
  end

  def create
    @checkout = build_checkout(checkout_params_with_user)

    if @checkout.fulfill
      sign_in_and_redirect
    else
      render :new
    end
  end

  private

  def build_checkout(arguments)
    checkout = plan.checkouts.build(arguments)
    CheckoutPrepopulator.new(checkout, current_user).prepopulate_with_user_info
    checkout
  end

  def checkout_params_with_user
    checkout_params.merge(
      stripe_customer_id: existing_stripe_customer_id,
      user: current_user
    )
  end

  def sign_in_and_redirect
    sign_in @checkout.user

    redirect_to(
      success_url,
      notice: t("checkout.flashes.success", name: @checkout.plan_name),
      flash: { purchase_amount: @checkout.price }
    )
  end

  def success_url
    if @checkout.includes_team?
      edit_team_path
    else
      practice_path
    end
  end

  def url_after_denied_access_when_signed_out
    sign_up_url
  end

  def checkout_params
    params.require(:checkout).permit(
      :address1,
      :address2,
      :city,
      :country,
      :email,
      :github_username,
      :name,
      :organization,
      :password,
      :payment_method,
      :quantity,
      :state,
      :stripe_coupon_id,
      :stripe_token,
      :zip_code
    )
  end

  def existing_stripe_customer_id
    if using_existing_card?
      current_user.stripe_customer_id
    end
  end

  def plan
    Plan.where(sku: params[:plan]).first
  end

  def using_existing_card?
    params[:use_existing_card] == "on"
  end
end
