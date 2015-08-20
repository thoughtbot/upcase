class AuthCallbacksController < ApplicationController
  def create
    @user = AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash
    sign_in @user
    redirect_to url_after_auth
    clear_return_to
  end

  private

  def url_after_auth
    if originated_from_sign_in_or_sign_up?
      custom_return_path_or_default(practice_path)
    elsif signing_up_from_new_checkout_flow?
      new_payment_path
    else
      auth_origin
    end
  end

  def originated_from_sign_in_or_sign_up?
    auth_origin =~ /^#{sign_in_url}/ || auth_origin =~ /^#{sign_up_url}/
  end

  def signing_up_from_new_checkout_flow?
    auth_origin =~ /#{page_path("landing")}/
  end

  def custom_return_path_or_default(default_path)
    ReturnPathFinder.new(auth_origin).return_path || default_path
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def auth_origin
    session[:return_to] || request.env["omniauth.origin"] || practice_url
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
