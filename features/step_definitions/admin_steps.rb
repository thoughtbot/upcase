When /^I am on admin home page$/ do
  visit "/admin"
end

Then /^I should see login form$/ do
  page.should have_selector('form#new_user')
end

Then /^I should see the admin interface$/ do
  page.should have_content("Dashboard")
  page.should have_content("Admin")
end

Then /^I should see the home page$/ do
  current_path.should == "/"
end

