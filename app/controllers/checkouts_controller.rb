class CheckoutsController < ApplicationController
  def new
    if current_user_has_active_subscription?
      redirect_to edit_subscription_path
    else
      @checkout = build_checkout_with_defaults
    end
  end

  def create
    @checkout =
      CheckoutBuilder.
        new(params: params,
            user: current_user,
            checkouts_collection: requested_subscribeable.checkouts).
        build

    if @checkout.save
      sign_in_checkout_user(@checkout)

      redirect_to(
        success_url,
        notice: t('checkout.flashes.success', name: @checkout.subscribeable_name)
      )
    else
      render :new
    end
  end

  private

  def build_checkout_with_defaults
    checkout = requested_subscribeable.checkouts.build
    CheckoutPrepopulator.new(checkout, current_user).prepopulate_with_user_info
    checkout
  end

  def sign_in_checkout_user(checkout)
    if signed_out? && checkout.user
      sign_in checkout.user
    end
  end

  def success_url
    @checkout.success_url(self)
  end

  def url_after_denied_access_when_signed_out
    sign_up_url
  end
end
