module Subscriber
  class InvoicesController < ApplicationController
    before_filter :authorize

    def index
      @invoices = SubscriptionInvoice.
        find_all_by_stripe_customer_id(current_user.stripe_customer_id)
    end

    def show
      @invoice = SubscriptionInvoice.new(params[:id])
      ensure_invoice_belongs_to_user
    end

    private

    def ensure_invoice_belongs_to_user
      if @invoice.user != current_user
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
