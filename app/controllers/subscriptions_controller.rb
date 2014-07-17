class SubscriptionsController < ApplicationController
  def new
    @catalog = Catalog.new

    render :layout => 'empty-body'
  end

  def edit
    @catalog = Catalog.new

    render :layout => 'header-only'
  end

  def update
    plan = IndividualPlan.find_by_sku!(params[:plan_id])
    current_user.subscription.change_plan(plan)
    redirect_to my_account_path, notice: I18n.t('subscriptions.flashes.change.success')
  end
end
