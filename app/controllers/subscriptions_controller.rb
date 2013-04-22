class SubscriptionsController < ApplicationController
  def destroy
    unsubscriber = Unsubscriber.new(current_user.subscription)
    unsubscriber.process
    redirect_to my_account_path
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer)
    customer.card = params['stripe_token']
    customer.save
    redirect_to my_account_path, notice: I18n.t('subscriptions.flashes.update.success')
  end
end
