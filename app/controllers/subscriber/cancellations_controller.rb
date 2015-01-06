class Subscriber::CancellationsController < ApplicationController
  before_filter :must_be_subscription_owner

  def new
    @cancellation = Cancellation.new(current_user.subscription)
  end

  def create
    @cancellation = Cancellation.new(
      current_user.subscription,
      cancellation_params[:reason]
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
