module Subscriber
  class PurchasesController < ApplicationController
    def create
      @purchaseable = Product.find(params[:purchaseable_id])

      SubscriberPurchase.new(@purchaseable, current_user).create
      render 'show'
    end
  end
end
