class SubscriptionsController < ApplicationController
  before_action :must_be_subscription_owner, only: %i(edit update)

  def new
    @landing_page = true
    @topics = LandingPageTopics.new.topics
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
