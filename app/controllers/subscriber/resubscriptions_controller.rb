module Subscriber
  class ResubscriptionsController < ApplicationController
    def create
      resubscription = make_resubscription
      if resubscription.fulfill
        flash[:notice] = t("subscriptions.flashes.resubscribe.success")
      else
        flash[:error] = t("subscriptions.flashes.resubscribe.failure")
      end
      redirect_to my_account_path
    end

    private

    def make_resubscription
      Resubscription.new(user: current_user, plan: Plan.professional)
    end
  end
end

