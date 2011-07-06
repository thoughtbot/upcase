Then /^I see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_xpath("//a[contains(.,'#{text_title}')]")
end

Then /^I do not see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_no_xpath("//a[contains(.,'#{text_title}')]")
end

Then /^the registration button should link to "([^"]*)"$/ do |href|
  page.find("#register-button")['href'].should == href
end
