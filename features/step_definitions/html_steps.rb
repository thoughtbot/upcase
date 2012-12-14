Then /^the registration button should link to "([^"]*)"$/ do |href|
  page.find_link('REGISTER FOR THIS WORKSHOP')['href'].should == href
end

Then /^"([^"]*)" should be in the ([\w\s]+) promo location$/ do |text, promo_location|
  page.should have_css(".promo-container.#{promo_location} h3", text: text)
end

Then /^the meta description should be "([^"]*)"$/ do |expected_description|
  meta_tag = page.find('meta[name=Description]')
  meta_tag['content'].should == expected_description
end

Then /^the meta keywords should be "([^"]*)"$/ do |expected_keywords|
  meta_tag = page.find('meta[name=Keywords]')
  meta_tag['content'].should == expected_keywords
end

Then /^the page should use the default meta description$/ do
  meta_tag = page.find('meta[name=Description]')
  meta_tag['content'].should == I18n.t('layouts.application.meta_description')
end

Then /^the page title should be "([^"]*)"$/ do |page_title|
  page.should have_css('title', text: page_title)
end
