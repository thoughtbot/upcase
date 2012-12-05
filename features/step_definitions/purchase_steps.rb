Given /^an unpaid purchase for "([^"]*)" with lookup "([^"]*)"$/ do |product_name, lookup|
  product = Product.find_by_name!(product_name)
  purchase = create(:purchase, purchaseable: product, payment_method: 'paypal')
  purchase.paid = false
  purchase.lookup = lookup
  purchase.save!
end

When /^I apply coupon code "([^"]*)" to product named "([^"]*)"$/ do |coupon_code, product_name|
  visit products_path
  click_link product_name
  click_link "Purchase for Yourself"
  click_link "Have a coupon code?"
  fill_in "Code", with: coupon_code
  click_button "Apply Coupon"
end

Then /^I should see the checkout form$/ do
  page.should have_css('form#new_purchase')
end

Then /^"([^"]*)" should be filled in with "([^"]*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

Then /^I should not see payment options$/ do
  page.should have_no_css('#billing-information')
end

Then /^I should see payment options$/ do
  page.should have_css('#billing-information')
end

When /^I completed the purchase$/ do
  fill_in_name_and_email
  click_button 'Submit Payment'
end

Then /^I should see that product "([^"]*)" is successfully purchased$/ do |product_name|
  page.should have_content("Thank you for purchasing #{product_name}")
end

When 'I choose to pay with Paypal' do
  uri = URI.parse(current_url)
  Purchase.host = "#{uri.host}:#{uri.port}"
  choose 'purchase_payment_method_paypal'
end

When 'I pay using Paypal' do
  uri = URI.parse(current_url)
  Purchase.host = "#{uri.host}:#{uri.port}"

  choose 'purchase_payment_method_paypal'
  fill_in_name_and_email
  click_button 'Proceed to Checkout'
end

When 'I submit the Paypal form' do
  click_button 'Pay using Paypal'
end

When /^I add a reader$/ do
  fill_in "reader_1", with: "cpytel"
end

Then /^an email should be sent out with subject containing "([^"]*)"$/ do |name|
  ActionMailer::Base.deliveries.should_not be_empty
  result = ActionMailer::Base.deliveries.any? do |email|
    email.subject =~ /#{name}/i
  end
end

Then /^I should see the link to the video page$/ do
  page.should have_css('a', href: /watch/)
end

Then /^I should see a list of (\d+) videos?$/ do |count|
  page.should have_css('.videoinfo', count: count)
end

Then /^I should see a video$/ do
  page.should have_css('iframe')
end

Then /^I should see the download links for video with id "([^"]*)"$/ do |video_id|
  page.should have_css('a', href: /#{video_id}\/download/)
end

Then /^I should see a list of other products$/ do
  page.should have_css('section', id: "products")
end

Then /^the first reader should be my github username$/ do
  find_field('reader_1').value.should == "thoughtbot"
end

Then /^I should see "([^"]*)" discounted (\d+)% with the text "([^"]*)"$/ do |product_name, discount_percentage, discount_title|
  product = Product.find_by_name!(product_name)
  page.should have_css '.discount-title', text: discount_title
  page.should have_css '.individual-purchase span', text: product.individual_price.to_s
  page.should have_css '.individual-purchase span.original-price', text: product.original_individual_price.to_s
  page.should have_css '.company-purchase span', text: product.company_price.to_s
  page.should have_css '.company-purchase span.original-price', text: product.original_company_price.to_s
end

Then /^I should see "([^"]*)" is not discounted$/ do |product_name|
  product = Product.find_by_name!(product_name)
  page.should_not have_css '.discount-title'
  page.should_not have_css '.individual-purchase span.original-price'
  page.should_not have_css '.company-purchase span.original-price'
end
