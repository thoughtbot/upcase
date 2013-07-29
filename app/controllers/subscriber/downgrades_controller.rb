class Subscriber::DowngradesController < ApplicationController
  def create
    current_user.subscription.downgrade
    redirect_to my_account_path,
      notice: t('subscriptions.flashes.downgrade.success')
  end
end
