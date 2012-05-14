module SessionHelpers
  def current_user
    User.find_by_remember_token(cookies['remember_token'])
  end

  def sign_in_as(user)
    cookies.merge("remember_token=#{user.remember_token}; path=/")
  end

  def fill_in_name_and_email
    fill_in 'Name', with: 'Eugene'
    fill_in 'Email', with: 'mr.the.plague@example.com'
  end
end

World(SessionHelpers)
