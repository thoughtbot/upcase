class SubscriptionsController < ApplicationController
  def new
    @plans = Plan.featured.active.ordered
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
    if cookies[:mentor_id].blank?
      @mentor = User.mentors.sample
      cookies[:mentor_id] ||= @mentor.id
    else
      @mentor = User.find(cookies[:mentor_id])
    end
  end
end
