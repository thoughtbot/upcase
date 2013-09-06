class SubscriptionsController < ApplicationController
  def index
    @plans = IndividualPlan.featured.active.ordered
    assign_mentor
  end

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

  private

  def assign_mentor
    @mentor = User.find_or_sample_mentor(cookies[:mentor_id])

    if cookies[:mentor_id].blank?
      cookies[:mentor_id] ||= @mentor.id
    end
  end
end
