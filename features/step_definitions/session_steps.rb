Given 'I am signed in as "$email"' do |email|
  user = Factory(:email_confirmed_user,
                 :email => email,
                 :password => 'password',
                 :password_confirmation => 'password')
  Given %{I sign in as "#{user.email}/password"}
end

Given 'I am signed in as an admin' do
  user = Factory(:admin,
                 :password => 'password',
                 :password_confirmation => 'password')
  Given %{I sign in as "#{user.email}/password"}
end

Given 'I am signed in as a student' do
  user = Factory(:email_confirmed_user,
                 :password => 'password',
                 :password_confirmation => 'password')
  Given %{I sign in as "#{user.email}/password"}
end
