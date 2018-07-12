class UsersController < Clearance::UsersController
  before_action :require_login, only: %i(edit update)

  def edit
  end

  def update
    if current_user.update_attributes(create_user_from_params)
      redirect_to my_account_path, notice: I18n.t("users.flashes.update.success")
    else
      render :edit
    end
  end

  def create_user_from_params
    user_params = params.require(:user).permit(
      :email, :password, :name, :github_username, :bio, :organization,
      :address1, :address2, :city, :state, :zip_code, :country,
      :unsubscribed_from_emails
    )

    unless user_params[:password].present?
      user_params.delete(:password)
    end

    user_params
  end

  def return_to
    session[:return_to] || params[:return_to]
  end
end
