class AuthCallbacksController < ApplicationController
  def create
    p auth_hash
    @user = User.find_or_create_from_auth_hash(auth_hash)
    sign_in @user
    redirect_to my_account_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
