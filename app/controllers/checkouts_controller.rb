class CheckoutsController < ApplicationController
  self.responder = Responders::CheckoutResponder
  respond_to :html

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
    @checkout = requested_subscribeable.checkouts.build(checkout_params)
    @checkout.user = current_user
    @checkout.stripe_customer_id = existing_stripe_customer_id
    CheckoutPrepopulator.new(@checkout, current_user).prepopulate_with_user_info

    respond_with @checkout
  end

  private

  def build_checkout_with_defaults
    checkout = requested_subscribeable.checkouts.build
    CheckoutPrepopulator.new(checkout, current_user).prepopulate_with_user_info
    checkout
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

  def using_existing_card?
    params[:use_existing_card] == "on"
  end
end
