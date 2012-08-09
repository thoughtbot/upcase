Given /^I have (\d+) (workshops|purchases)$/ do |count, type|
  user = User.last

  count.to_i.times do
    if type == 'workshops'
      user.registrations << create(:registration)
    else
      user.purchases << create(:purchase)
    end
  end
end

Then /^I should see the edit account form$/ do
  page.should have_selector('form.formtastic.user')
end

Then /^I should see my (\d+) (workshops|purchases)$/ do |count, type|
  page.should have_css("ol.#{type} li", count: count.to_i)
end
