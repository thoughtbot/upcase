Then /^the registration button should link to "([^"]*)"$/ do |href|
  page.find_link('REGISTER FOR THIS WORKSHOP')['href'].should == href
end

Then /^"([^"]*)" should be in the ([\w\s]+) promo location$/ do |text, promo_location|
  page.should have_css(".promo-container.#{promo_location} h3", text: text)
end
