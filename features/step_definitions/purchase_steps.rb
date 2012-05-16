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

Then /^I should see payment options$/ do
  page.should have_css('#billing-information')
end

When /^I completed the purchase$/ do
  stub_fetch_api
  fill_in_name_and_email
  click_button 'Submit Payment'
end

Then /^I should see that product "([^"]*)" is successfully purchased$/ do |product_name|
  page.body.should =~ /Thank you.*#{product_name}/
end

When 'I pay using Paypal' do
  stub_fetch_api
  uri = URI.parse(current_url)
  Purchase.host = "#{uri.host}:#{uri.port}"

  choose 'purchase_payment_method_paypal'
  fill_in_name_and_email
  click_button 'Proceed to Checkout'
end

When 'I submit the Paypal form' do
  click_button 'Pay using Paypal'
end
