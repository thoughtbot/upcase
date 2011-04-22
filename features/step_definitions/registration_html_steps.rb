Then 'I see the course registration page for "$course_name"' do |course_name|
  page.should have_content(course_name)
  page.should have_content("Register")
end

Then /^I follow "([^"]*)" within the registration for "([^"]*)"$/ do |link_text, user_email|
  user = User.find_by_email!(user_email)
  within "##{dom_id(Registration.find_by_user_id!(user.id))}" do
    click_link link_text
  end
end
