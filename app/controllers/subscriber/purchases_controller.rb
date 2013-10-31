module Subscriber
  class PurchasesController < ApplicationController
    def new
      @purchaseable = PurchaseableDecorator.new(requested_purchaseable)
    end

    def create
      @purchaseable = requested_purchaseable
      subscriber_purchase = SubscriberPurchase.new(@purchaseable,
        current_user,
        comments)
      @purchase = subscriber_purchase.create

      redirect_to @purchase, notice: t('subscriber_purchase.flashes.success')
    end

    private

    def comments
      if params[:subscriber_purchase]
        params[:subscriber_purchase][:comments]
      end
    end
  end
end
