Given 'I am signed in as "$email"' do |email|
  user = Factory(:user, :email => email)
  Given %{I sign in as "#{user.email}"}
end

Given 'I am signed in as an admin' do
  user = Factory(:admin)
  Given %{I sign in as "#{user.email}"}
end

Given 'I am signed in as a student' do
  user = Factory(:user)
  Given %{I sign in as "#{user.email}"}
end
