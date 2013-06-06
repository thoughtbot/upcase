class UsersController < Clearance::UsersController
  before_filter :authorize, only: [:edit, :update]
  layout 'dashboard'

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to my_account_path
    else
      render action: :edit
    end
  end
end
