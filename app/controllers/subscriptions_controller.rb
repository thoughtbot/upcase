class SubscriptionsController < ApplicationController
  before_filter :must_be_subscription_owner, only: [:edit, :update]

  def new
  end

  def edit
    @catalog = Catalog.new
  end

  def update
    current_user.subscription.change_plan(sku: params[:plan_id])
    redirect_to my_account_path,
                notice: I18n.t("subscriptions.flashes.change.success")
  end
end
