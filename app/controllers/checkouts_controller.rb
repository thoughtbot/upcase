class CheckoutsController < ApplicationController
  def new
    if current_user_has_active_subscription?
      redirect_to(
        edit_subscription_path,
        notice: t("checkout.flashes.already_subscribed")
      )
    else
      @checkout = build_checkout_with_defaults
    end
  end

  def create
    @checkout = plan.checkouts.build(checkout_params)
    @checkout.user = current_user
    @checkout.stripe_customer_id = existing_stripe_customer_id
    CheckoutPrepopulator.new(@checkout, current_user).prepopulate_with_user_info

    if @checkout.save
      sign_in_checkout_user(@checkout)

      redirect_to(
        success_url,
        notice: t(
          "checkout.flashes.success",
          name: @checkout.plan_name
        ),
        flash: {
          purchase_amount: @checkout.price
        }
      )
    else
      render :new
    end
  end

  private

  def build_checkout_with_defaults
    checkout = plan.checkouts.build
    CheckoutPrepopulator.new(checkout, current_user).prepopulate_with_user_info
    checkout
  end

  def sign_in_checkout_user(checkout)
    if signed_out? && checkout.user
      sign_in checkout.user
    end
  end

  def success_url
    if @checkout.includes_team?
      edit_team_path
    else
      dashboard_path
    end
  end

  def url_after_denied_access_when_signed_out
    sign_up_url
  end

  def checkout_params
    params.
      require(:checkout).
      permit(:stripe_coupon_id,
             :name,
             :email,
             :password,
             :github_username,
             :organization,
             :address1,
             :address2,
             :city,
             :state,
             :zip_code,
             :country,
             :payment_method,
             :stripe_token,
             :quantity)
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
