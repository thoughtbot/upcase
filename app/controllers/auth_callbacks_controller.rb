class AuthCallbacksController < ApplicationController
  def create
    @user = AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash
    sign_in @user
    redirect_to url_after_auth
  end

  private

  def url_after_auth
    if originated_from_sign_in_or_sign_up?
      custom_return_path_or_default(dashboard_path)
    else
      auth_origin
    end
  end

  def originated_from_sign_in_or_sign_up?
    auth_origin =~ /^#{sign_in_url}/ || auth_origin =~ /^#{sign_up_url}/
  end

  def custom_return_path_or_default(default_path)
    ReturnPathFinder.new(auth_origin).return_path || default_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def auth_origin
    session[:return_to] || request.env['omniauth.origin'] || dashboard_url
  end
end
