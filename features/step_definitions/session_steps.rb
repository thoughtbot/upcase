Given 'I am signed in as "$email"' do |email|
  user = Factory(:user, :email => email, :password => 'password')
  Given %{I sign in as "#{user.email}/password"}
end

Given 'I am signed in as an admin' do
  user = Factory(:admin, :password => 'password')
  Given %{I sign in as "#{user.email}/password"}
end

Given 'I am signed in as a student' do
  user = Factory(:user, :password => 'password')
  Given %{I sign in as "#{user.email}/password"}
end
