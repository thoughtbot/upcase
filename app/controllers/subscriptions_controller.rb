class SubscriptionsController < ApplicationController
  before_filter :must_be_subscription_owner, only: [:edit, :update]

  def new
    if vanity_selects_existing_landing_page?
      @landing_page = LandingPage.new

      render layout: "landing_pages"
    else
      redirect_to page_path("landing")
    end
  end

  def edit
    @catalog = Catalog.new

    render layout: "header-only"
  end

  def update
    current_user.subscription.change_plan(sku: params[:plan_id])
    redirect_to my_account_path,
                notice: I18n.t("subscriptions.flashes.change.success")
  end

  private

  def vanity_selects_existing_landing_page?
    ab_test(:landing_page) == :existing
  end
end
