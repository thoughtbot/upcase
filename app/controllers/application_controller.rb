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

  def current_user_readers
    if signed_in? && current_user.github_username.present?
      [current_user.github_username]
    else
      []
    end
  end

  def current_user_name
    if signed_in?
      current_user.name
    end
  end

  def current_user_first_name
    if signed_in?
      current_user.first_name
    end
  end

  def current_user_last_name
    if signed_in?
      current_user.last_name
    end
  end

  def current_user_email
    if signed_in?
      current_user.email
    end
  end
end
