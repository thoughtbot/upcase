module Subscriber
  class InvoicesController < ApplicationController
    before_filter :must_be_subscription_owner

    def index
      @invoices = Invoice.
        find_all_by_stripe_customer_id(current_user.stripe_customer_id)
    end

    def show
      @invoice = Invoice.new(params[:id])
    end
  end
end
