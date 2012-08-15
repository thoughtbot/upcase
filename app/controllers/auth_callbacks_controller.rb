class AuthCallbacksController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    p @user.errors
    sign_in @user
    redirect_to my_account_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
