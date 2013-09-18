class Subscriber::DowngradesController < ApplicationController
  def create
    current_user.subscription.change_plan(IndividualPlan.downgraded)
    redirect_to my_account_path,
      notice: t('subscriptions.flashes.downgrade.success')
  end
end
