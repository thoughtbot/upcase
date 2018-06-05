class Subscriber::CancellationsController < ApplicationController
  before_action :must_be_subscription_owner

  def new
    @cancellation = Cancellation.new(subscription: current_user.subscription)
  end

  def create
    @cancellation = Cancellation.new(
      subscription: current_user.subscription,
      reason: cancellation_params[:reason],
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
