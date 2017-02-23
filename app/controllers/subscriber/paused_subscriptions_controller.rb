module Subscriber
  class PausedSubscriptionsController < ApplicationController
    before_filter :must_be_subscription_owner

    def create
      @subscription_pauser = PausedSubscription.new(current_user.subscription)

      if @subscription_pauser.schedule
        notify_pausing_subscriber

        redirect_to(
          my_account_path,
          notice: t("subscriptions.flashes.pause.success"),
        )
      else
        render "subscriber/cancellations#new"
      end
    end

    def notify_pausing_subscriber
      PauseMailer.
        pause(current_user.subscription).
        deliver_later
    end
  end
end
