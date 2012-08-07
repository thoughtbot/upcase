Given /^I have "([^"]*)" purchases$/ do |purchase_count|
  user = User.last

  purchase_count.to_i.times do
    user.purchases << create(:purchase)
  end
end

Then /^I should see the edit account form$/ do
  page.should have_selector('form.formtastic.user')
end

Then /^I should see my "([^"]*)" purchases$/ do |purchase_count|
  page.should have_css("ul.purchases li", count: purchase_count.to_i)
end
