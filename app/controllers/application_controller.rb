class ApplicationController < ActionController::Base
  include Clearance::Authentication

  cattr_accessor :km_http_client

  helper :all

  protect_from_forgery

  protected

  def must_be_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def km_http_client
    @@km_http_client.new(KISSMETRICS_API_KEY)
  end

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def subscription_product
    Product.subscriptions.first
  end
  helper_method :subscription_product
end
