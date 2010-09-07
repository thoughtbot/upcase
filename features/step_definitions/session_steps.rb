Given 'I am signed in as "$email"' do |email|
  user = Factory(:email_confirmed_user,
                 :email => email,
                 :password => 'password',
                 :password_confirmation => 'password')
  Given %{I sign in as "#{user.email}/password"}
end
