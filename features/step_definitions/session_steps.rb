Given 'I am signed in as "$email"' do |email|
  user = create(:user, email: email)
  Given %{I sign in as "#{user.email}"}
end

Given 'I am signed in as an admin' do
  user = create(:admin)
  Given %{I sign in as "#{user.email}"}
end

Given 'I am signed in as a student' do
  user = create(:user)
  Given %{I sign in as "#{user.email}"}
end
