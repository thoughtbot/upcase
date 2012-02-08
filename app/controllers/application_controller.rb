class ApplicationController < ActionController::Base
  include Clearance::Authentication

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
    KISSMETRICS_CLIENT_CLASS.new(KISSMETRICS_API_KEY)
  end
end
