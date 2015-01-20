module Subscriber
  class InvoicesController < ApplicationController
    before_filter :require_login

    def index
      @invoices = Invoice.
        find_all_by_stripe_customer_id(current_user.stripe_customer_id)
    end

    def show
      @invoice = Invoice.new(params[:id])
      if @invoice.user == current_user
        render
      else
        not_found
      end
    rescue Stripe::InvalidRequestError
      not_found
    end

    private

    def not_found
      raise ActionController::RoutingError, "No invoice #{params[:id]}"
    end
  end
end
