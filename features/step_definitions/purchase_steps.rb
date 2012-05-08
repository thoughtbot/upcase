When /^I apply coupon code "([^"]*)" to product named "([^"]*)"$/ do |coupon_code, product_name|
  visit root_path
  click_link product_name
  click_link "Purchase for Yourself"
  click_link "Have a coupon code?"
  fill_in "Code", with: coupon_code
  click_button "Apply Coupon"
end

Then /^I should not see payment options$/ do
  page.should have_no_css('#billing-information')
end

When /^I completed the purchase$/ do
  FetchAPI::Order.stubs(:create)
  FetchAPI::Base.stubs(:basic_auth)
  FetchAPI::Order.stubs(:find).returns(stub(:link_full => "http://fetchurl"))

  fill_in 'Name', with: 'Eugene'
  fill_in 'Email', with: 'mr-the-plague@example.com'
  click_button 'Submit Payment'
end

Then /^I should see that product "([^"]*)" is successfully purchased$/ do |product_name|
  page.body.should =~ /Thank you.*#{product_name}/
end
