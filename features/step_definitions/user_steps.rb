Given /^I have (\d+) paid purchases$/ do |count|
  user = User.last

  count.to_i.times do
    user.purchases << create(:paid_purchase)
  end
end

Given /^I have a prime subscription$/ do
  step 'github is stubbed'

  user = User.last
  user.update_attributes(github_username: 'thoughtbot')
  mentor = create(:user)

  create(:plan_purchase, user: user, mentor_id: mentor.id)
end

Then /^I should see the edit account form$/ do
  page.should have_selector('form.formtastic.user')
end

Then /^I should see my (\d+) (workshops|purchases|subscription)$/ do |count, type|
  page.should have_css("ol.#{type} li", count: count.to_i)
end

Then /^the site should know my github username$/ do
  visit my_account_path
  find_field("Github username").value.should == "cpytel"
end

When /^I visit my profile$/ do
  visit my_account_path
end
