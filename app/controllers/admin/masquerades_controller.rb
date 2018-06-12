module Admin
  class MasqueradesController < ApplicationController
    before_action :must_be_admin

    def create
      session[:admin_id] = current_user.id
      user = User.find(params[:user_id])
      sign_in user
      redirect_to root_path, notice: "Now masquerading as #{user.email}"
    end

    def destroy
      sign_in User.find(session[:admin_id])
      session.delete(:admin_id)
      redirect_to rails_admin_path, notice: "Stopped masquerading"
    end
  end
end
