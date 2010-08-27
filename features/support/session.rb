module SessionHelpers
  def current_user
    User.find_by_remember_token(cookies['remember_token'])
  end

  def sign_in_as(user)
    cookies.merge("remember_token=#{user.remember_token}; path=/")
  end
end

World(SessionHelpers)
