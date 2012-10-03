Then /^the registration button should link to "([^"]*)"$/ do |href|
  page.find("#register-button")['href'].should == href
end
