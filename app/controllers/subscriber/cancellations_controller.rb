class Subscriber::CancellationsController < ApplicationController
  before_filter :authorize

  def new
    @cancellation = build_cancellation
  end

  def create
    cancellation = build_cancellation
    cancellation.schedule
    redirect_to(
      my_account_path,
      notice: t('subscriptions.flashes.cancel.success')
    )
  end

  private

  def build_cancellation
    Cancellation.new(current_user.subscription)
  end
end
