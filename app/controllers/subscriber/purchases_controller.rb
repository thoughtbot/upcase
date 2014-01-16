module Subscriber
  class PurchasesController < ApplicationController
    def new
      @purchaseable = PurchaseableDecorator.new(requested_purchaseable)
    end

    def create
      @purchaseable = requested_purchaseable
      subscriber_purchase = SubscriberPurchase.new(@purchaseable, current_user)
      @purchase = subscriber_purchase.create

      redirect_to @purchase, notice: t('subscriber_purchase.flashes.success')
    end
  end
end
