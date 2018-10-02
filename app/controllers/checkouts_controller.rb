class CheckoutsController < ApplicationController
  before_action :redirect_check_out_not_needed, only: [:new]
  before_action :redirect_when_plan_not_found, only: [:create]
  before_action :redirect_when_already_subscribed, only: [:create]

  def new
    build_checkout({}) do |checkout|
      @landing = true
      @checkout = checkout
      render :new
    end
  end

  def create
    build_checkout(checkout_params) do |checkout|
      success = checkout.fulfill
      sign_in_created_user checkout.user
      if success
        session.delete(:coupon)
        track_subscription(checkout)
        redirect_after_checkout checkout
      else
        @checkout = checkout
        render :new
      end
    end
  end

  private

  def redirect_check_out_not_needed
    redirect_to(
      sign_in_path,
      notice: t("checkout.flashes.subscription_not_needed"),
    )
  end

  def redirect_when_plan_not_found
    unless plan.present?
      redirect_to(
        new_checkout_path(plan: Plan.professional),
        notice: I18n.t("checkout.flashes.plan_not_found"),
      )
    end
  end

  def redirect_when_already_subscribed
    if current_user.subscriber?
      redirect_to(
        root_path,
        notice: t("checkout.flashes.already_subscribed"),
      )
    end
  end

  def build_checkout(arguments)
    checkout = plan.checkouts.build(
      arguments.
        merge(default_params).
        merge(coupon_param).
        merge(campaign_param),
    )

    if checkout.has_invalid_coupon?
      redirect_from_invalid_coupon
    else
      yield checkout
    end
  end

  def track_subscription(checkout)
    analytics.track_subscribed(
      context: {
        campaign: session[:campaign_params],
      },
      plan: checkout.plan_sku,
      revenue: checkout.price,
    )
  end

  def redirect_from_invalid_coupon
    redirect_to(
      new_checkout_path(plan.sku),
      notice: t("checkout.flashes.invalid_coupon", code: session[:coupon]),
    )
    session.delete(:coupon)
  end

  def default_params
    if signed_in?
      {
        user: current_user,
        github_username: current_user.github_username,
        stripe_customer_id: current_user.stripe_customer_id,
      }
    else
      {}
    end
  end

  def coupon_param
    {
      stripe_coupon_id: session[:coupon],
    }
  end

  def campaign_param
    if session[:campaign_params]
      {
        utm_source: session[:campaign_params][:utm_source],
      }
    else
      {}
    end
  end

  def sign_in_created_user(user)
    if user.persisted?
      sign_in user
    end
  end

  def redirect_after_checkout(checkout)
    redirect_to(
      success_url(checkout),
      notice: t("checkout.flashes.success"),
      flash: { purchase_amount: checkout.price },
    )
  end

  def success_url(checkout)
    if checkout.plan_includes_team?
      edit_team_path
    else
      onboarding_policy.root_path
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
      :zip_code,
    )
  end

  def plan
    Plan.find_by(sku: params[:plan])
  end
end
