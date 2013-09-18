class CreditCardsController < ApplicationController
  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    customer.card = params['stripe_token']
    begin
      customer.save
      redirect_to my_account_path, notice: I18n.t('subscriptions.flashes.update.success')
    rescue Stripe::CardError => error
      redirect_to my_account_path, notice: error.message
    end
  end
end
