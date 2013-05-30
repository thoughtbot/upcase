class UsersController < Clearance::UsersController
  before_filter :authorize, only: [:edit, :update]

  def new
    @user = user_from_params
    render template: 'users/new', layout: 'dashboard'
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: 'users/new', layout: 'dashboard'
    end
  end

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
