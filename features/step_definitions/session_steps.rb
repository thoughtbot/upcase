Given 'I am signed in as "$email"' do |email|
  user = create(:user, :email => email, :password => 'password')
  steps %{Given I sign in as "#{user.email}/password"}
end

Given 'I am signed in as an admin' do
  user = create(:admin, :password => 'password')
  steps %{Given I sign in as "#{user.email}/password"}
end

Given 'I am signed in as a student' do
  user = create(:user, :password => 'password')
  steps %{Given I sign in as "#{user.email}/password"}
end
