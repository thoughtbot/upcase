Then /^the registration button should link to "([^"]*)"$/ do |href|
  page.find_link('REGISTER FOR THIS WORKSHOP')['href'].should == href
end
