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
      sign_in_purchasing_user(@checkout)

      redirect_to(
        success_url,
        notice: t('checkout.flashes.success', name: @checkout.checkoutable_name)
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

  def sign_in_purchasing_user(checkout)
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

  def polymorphic_checkoutable_template
    "#{@checkoutable.to_partial_path}_checkout_show"
  end

  def variant
    if params[:variant].present?
      params[:variant]
    else
      'individual'
    end
  end

  def redirect_for_user_with_subscription
    if current_user_plan_includes_checkoutable?
      redirect_to_subscriber_checkout_or_default(dashboard_path)
    else
      redirect_for_subscription_without_access
    end
  end

  def redirect_for_subscription_without_access
    redirect_to edit_subscription_path
  end

  def redirect_for_non_subscriber_purchasing_a_workshop
    redirect_to new_subscription_path
  end
end
