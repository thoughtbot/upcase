module Subscriber
  class ReactivationsController < ApplicationController
    def create
      reactivation = Reactivation.new(subscription: current_user.subscription)
      if reactivation.fulfill
        analytics.track_subscription_reactivated
        flash[:notice] = t("subscriptions.flashes.reactivate.success")
      else
        flash[:error] = t("subscriptions.flashes.reactivate.failure")
      end
      redirect_to my_account_path
    end
  end
end
