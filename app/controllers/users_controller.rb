class UsersController < Clearance::UsersController
  before_action :require_login, only: %i[edit update]

  def edit
  end

  def update
    if current_user.update(filtered_user_params)
      redirect_to my_account_path, notice: I18n.t("users.flashes.update.success")
    else
      render :edit
    end
  end

  def filtered_user_params
    if user_params[:password].present?
      user_params
    else
      user_params.except(:password)
    end
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :name, :github_username, :bio, :organization,
      :address1, :address2, :city, :state, :zip_code, :country,
      :unsubscribed_from_emails
    )
  end

  def return_to
    session[:return_to] || params[:return_to]
  end
end
