class CheckoutsController < ApplicationController
  before_action :redirect_when_plan_not_found

  def new
    if current_user_has_active_subscription?
      redirect_to(
        edit_subscription_path,
        notice: t("checkout.flashes.already_subscribed")
      )
    else
      @checkout = build_checkout(stripe_coupon_id: session[:coupon])
      initialize_checkout_from_user
    end
  end

  def create
    @checkout = build_checkout(checkout_params_with_customer_and_coupon)

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
    plan.checkouts.build arguments.merge(default_arguments)
  end

  def checkout_params_with_customer_and_coupon
    checkout_params.merge(
      stripe_customer_id: current_user.try(:stripe_customer_id),
      stripe_coupon_id: session[:coupon]
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
    if @checkout.plan_includes_team?
      edit_team_path
    else
      practice_path
    end
  end

  def default_arguments
    { user: current_user }.merge(github_argument)
  end

  def github_argument
    github = current_user.try(:github_username)

    if github.present?
      { github_username: github }
    else
      {}
    end
  end

  def initialize_checkout_from_user
    if current_user.present?
      AttributesCopier.new(
        target: @checkout,
        source: current_user,
        attributes: Checkout::COMMON_ATTRIBUTES
      ).copy_present_attributes
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

  def using_existing_card?
    params[:use_existing_card] == "on"
  end
end
