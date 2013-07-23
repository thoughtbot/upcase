class Subscriber::CancellationsController < ApplicationController
  before_filter :authorize

  def new
  end

  def create
    cancellation = Cancellation.new(current_user.subscription)
    cancellation.schedule
    redirect_to my_account_path,
      notice: t('subscriptions.flashes.cancel.success')
  end
end
