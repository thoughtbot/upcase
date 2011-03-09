When 'I follow the link to $link_description' do |link_description|
  text_title_or_id = link_to(link_description)
  click_link(text_title_or_id)
end

Then /^I see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_xpath("//a[contains(.,'#{text_title}')]")
end

Then /^I do not see the link to the admin interface$/ do
  text_title = link_to('admin interface')
  page.should have_no_xpath("//a[contains(.,'#{text_title}')]")
end

Then /^the coupon form should be visible$/ do
  page.evaluate_script("$('.coupon form:visible').length").should == 1
end

Then /^the coupon form should be hidden$/ do
  page.evaluate_script("$('.coupon form:visible').length").should == 0
end

Then /^the coupon form link should be hidden$/ do
  page.evaluate_script("$('#total a:visible').length").should == 0
end
