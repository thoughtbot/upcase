class Subscriber::ReactivationsController < ApplicationController
  def create
    reactivation = Reactivation.new(subscription: current_user.subscription)
    reactivation.fulfill

    redirect_to(
      my_account_path,
      notice: t("subscriptions.flashes.reactivate.success")
    )
  end
end
