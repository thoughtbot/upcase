When /^I view all products/ do
  click_link 'VIEW ALL'
end

When /^I add a download with file name "([^"]*)" and description "([^"]*)"$/ do |file_name, description|
  click_link "Add a download"

  path = File.join(Rails.root,"tmp/",file_name)
  File.open(path, 'w+') do |f|
    f.puts "Ths is a test file"
  end
  attach_file "Download", path
  fill_in "Download Description", with: description
end

When /^I remove a download with file name "([^"]*)"$/ do |file_name|
  click_link 'remove'
end

Then /^I should see "([^"]*)" in input field$/ do |text|
  page.should have_css('input', :value => "#{text}")
end

Then /^I should not see "([^"]*)" in input field$/ do |text|
  page.should_not have_css('input', :value => "#{text}")
end

When /^a product named "([^"]*)"$/ do |product_name|
  create(:product, fulfillment_method: "fetch", name: product_name, product_type: 'video')
end

When /^a video download product named "([^"]*)"$/ do |product_name|
  product = create(:product, fulfillment_method: "fetch", name: product_name, product_type: 'video')
  create(:download, download_file_name: "test.txt", description: "test desc", purchaseable: product)
  create(:video, watchable: product)
end

Given /^there is a github product named "([^"]*)"$/ do |product_name|
  create(:product, fulfillment_method: "github", name: product_name, product_type: "book")
end

Given /^there is an external product named "([^"]*)"$/ do |product_name|
  create(:product,
    fulfillment_method: "external",
    name: product_name,
    product_type: "book",
    external_purchase_url: "http://external.com",
    external_purchase_name: "Amazon",
    external_purchase_description: "Available in Paperback and Kindle")
end

Then /^the purchase link should link to the external product$/ do
  page.should have_css(".license a[href='http://external.com']")
end

When /^I view the product "([^"]*)"$/ do |name|
  product = Product.find_by_name!(name)
  visit product_path(product, product_pricing: "primary")
end

Then 'I should see the book sample graphic' do
  find('.show_sample #book-graphic')
end

Then 'I should not see the book sample graphic' do
  find('.hide_sample #book-graphic')
end

When 'I view Test-Driven Rails resources' do
  visit '/test-driven-rails-resources'
end

Then 'I should see links to good Test-Driven Rails resources' do
  page.should have_css('a[href*="0132350882"]')
end
