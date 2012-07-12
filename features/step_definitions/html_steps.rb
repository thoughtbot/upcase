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

Then /^I should see a page not found error$/ do
  page.body.should match(/ActiveRecord::RecordNotFound|ActionController::RoutingError|AbstractController::ActionNotFound/)
end

Then /^the page title should be "([^"]*)"$/ do |title|
  page.evaluate_script("document.title").should == title
end

Then /^the page url should be "([^"]*)"$/ do |path|
  page.evaluate_script("location.pathname").should == path
end
