class Subscriber::CancellationsController < ApplicationController
  before_filter :authorize

  def new
    @cancellation = build_cancellation
  end

  def create
    cancellation = build_cancellation
    cancellation.schedule
    redirect_to(
      after_cancellation_path,
      notice: t('subscriptions.flashes.cancel.success')
    )
  end

  private

  def build_cancellation
    Cancellation.new(current_user.subscription)
  end

  def after_cancellation_path
    if current_user.subscription.last_charge
      new_subscriber_refund_path
    else
      my_account_path
    end
  end
end
