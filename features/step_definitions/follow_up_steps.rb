When /^I follow the remove link for the "([^"]*)" follow up$/ do |email|
  follow_up = FollowUp.find_by_email!(email)
  within "#follow_up_#{follow_up.id}" do
    find("a.remove-followup").click
  end
end

Then /^I should not see the "([^"]*)" follow up$/ do |email|
  page.should have_no_css("li.follow_up input[value='#{email}']")
end

Then /^I should see that "([^"]*)" has been notified on "([^"]*)"$/ do |email, date|
  within(:xpath, "//input[@value='#{email}']/..") do
    page.should have_content("Notified on #{date}")
  end
end
