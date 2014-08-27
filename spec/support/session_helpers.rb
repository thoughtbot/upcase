module SessionHelpers
  def sign_in
    sign_in_as create(:user)
  end

  def sign_in_as(user)
    @current_user = user
    visit root_path(as: @current_user)
  end

  def current_user
    @current_user
  end
end
