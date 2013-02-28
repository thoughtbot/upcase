class SubscriptionsController < ApplicationController
  def destroy
    unsubscriber = Unsubscriber.new(current_user.subscription)
    unsubscriber.process
    redirect_to my_account_path
  end
end
