class Subscriber::DiscountsController < ApplicationController
  def create
    Discounter.new(
      subscription: current_user.subscription,
      discounted_plan: Plan.discounted_annual
    ).switch_to_discounted_annual_plan

    redirect_to(
      my_account_path,
      notice: t("subscriptions.flashes.discount.success")
    )
  end
end
