class Subscriber::RefundsController < ApplicationController
  before_filter :authorize

  def new
    @cancellation = build_cancellation
  end

  def create
    cancellation = build_cancellation
    cancellation.cancel_and_refund
    redirect_to(
      my_account_path,
      notice: t('subscriptions.flashes.refund.success')
    )
  end

  private

  def build_cancellation
    Cancellation.new(current_user.subscription)
  end
end
