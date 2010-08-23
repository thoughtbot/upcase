Then 'I am signed in as:' do |table|
  user_hash = table.hashes.first
  user = User.find_by_email!(user_hash[:email])
  user.first_name.should == user_hash['first name']
  user.last_name.should == user_hash['last name']

  page.should have_content('Sign out')
end
