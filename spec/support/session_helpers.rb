module SessionHelpers
  def stub_signed_in(result = true)
    view_stubs(:signed_in?).and_return(result)
  end

  def stub_signed_out(result = true)
    view_stubs(:signed_out?).and_return(result)
  end

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
