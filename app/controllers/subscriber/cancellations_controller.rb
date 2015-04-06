class Subscriber::CancellationsController < ApplicationController
  before_filter :must_be_subscription_owner

  def new
    @cancellation = Cancellation.new(
      subscription: current_user.subscription
    )
    @cancellation_alternative = CancellationAlternative.new(
      current_plan: current_user.subscription.plan,
      discounted_plan: Plan.discounted_annual
    )
  end

  def create
    @cancellation = Cancellation.new(
      subscription: current_user.subscription,
      reason: cancellation_params[:reason]
    )
    @cancellation_alternative = CancellationAlternative.new(
      current_plan: current_user.subscription.plan,
      discounted_plan: Plan.discounted_annual
    )

    if @cancellation.schedule
      redirect_to(
        my_account_path,
        notice: t("subscriptions.flashes.cancel.success")
      )
    else
      render :new
    end
  end

  private

  def cancellation_params
    params.require(:cancellation).permit(:reason)
  end
end
