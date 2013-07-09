class AuthCallbacksController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    sign_in @user
    redirect_to url_after_auth
  end

  protected

  def url_after_auth
    if originated_from_sign_in_or_sign_up?
      my_account_path
    else
      auth_origin
    end
  end

  def originated_from_sign_in_or_sign_up?
    auth_origin == sign_in_url || auth_origin == sign_up_url
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def auth_origin
    request.env['omniauth.origin']
  end
end
