Given /^I have (\d+) paid purchases$/ do |count|
  user = User.last

  count.to_i.times do
    user.purchases << create(:paid_purchase)
  end
end

Then /^I should see the edit account form$/ do
  page.should have_selector('form.formtastic.user')
end

Then /^I should see my (\d+) (workshops|purchases)$/ do |count, type|
  page.should have_css("ol.#{type} li", count: count.to_i)
end

Then /^the site should know my github username$/ do
  visit my_account_path
  find_field("Github username").value.should == "cpytel"
end

Then /^the site should have my github information$/ do
  visit my_account_path
  find_field("user_first_name").value.should == "Test"
  find_field("user_last_name").value.should == "User"
  find_field("Email").value.should == "user@example.com"
  find_field("Github username").value.should == "thoughtbot"
end

Then /^I should have no password field$/ do
  page.should_not have_css("#user_password")
end

When /^I visit my profile$/ do
  visit my_account_path
end
