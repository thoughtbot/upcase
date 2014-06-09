class UsersController < Clearance::UsersController
  before_filter :authorize, only: [:edit, :update]

  def new
    @user = user_from_params
    render template: 'users/new', layout: 'header-only'
  end

  def create
    @user = User.new(create_user_from_params)

    if @user.save
      AssociatePreviousPurchases.create_associations_for(@user)
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: 'users/new', layout: 'header-only'
    end
  end

  def edit
  end

  def update
    if current_user.update_attributes(create_user_from_params)
      redirect_to my_account_path
    else
      render action: :edit
    end
  end

  def create_user_from_params
    params.require(:user).permit(
      :email, :password, :name, :github_username, :bio, :organization,
      :address1, :address2, :city, :state, :zip_code, :country
    )
  end

  def return_to
    session[:return_to] || params[:return_to]
  end
end
