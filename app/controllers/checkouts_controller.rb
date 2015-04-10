class CheckoutsController < ApplicationController
  before_action :redirect_when_plan_not_found

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
    @checkout = build_checkout(checkout_params)

    if @checkout.fulfill
      session.delete(:coupon)
      sign_in_and_redirect
    else
      render :new
    end
  end

  private

  def redirect_when_plan_not_found
    unless plan.present?
      redirect_to(
        new_checkout_path(plan: Plan.popular),
        notice: I18n.t("checkout.flashes.plan_not_found")
      )
    end
  end

  def build_checkout(arguments)
    plan.checkouts.build(arguments.merge(default_params))
  end

  def default_params
    if current_user
      {
        user: current_user,
        github_username: current_user.github_username,
        stripe_customer_id: current_user.stripe_customer_id,
        stripe_coupon_id: session[:coupon]
      }
    else
      {
        stripe_coupon_id: session[:coupon]
      }
    end
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
    if @checkout.plan_includes_team?
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
      :stripe_token,
      :zip_code
    )
  end

  def plan
    Plan.find_by(sku: params[:plan])
  end
end
