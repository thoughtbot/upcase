module SessionHelpers
  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end

  def current_user
    @current_user
  end

  def sign_out
    visit root_path(as: nil)
  end
end
