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

When /^I attach an image name "([^"]*)" to the product$/ do |image_name|
  path = File.join(Rails.root, "tmp/", image_name)
  test_image_path = File.join(Rails.root,"features/support/files/test.jpg")
  FileUtils.cp(test_image_path, path)
  attach_file "Product image", path
end

When /^I should see an image with name "([^"]*)"$/ do |image_name|
  page.should have_selector("img", src: /#{image_name}/)
end

When /^a product named "([^"]*)"$/ do |product_name|
  create(:product, fulfillment_method: "fetch", name: product_name, product_type: 'video')
end

When /^a video download product named "([^"]*)"$/ do |product_name|
  product = create(:product, fulfillment_method: "fetch", name: product_name, product_type: 'video')
  create(:download, download_file_name: "test.txt", description: "test desc", purchaseable: product)
  create(:video, purchaseable: product)
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
  visit product_path(Product.find_by_name!(name))
end

Then /^I should see a product alert for the in-person workshop$/ do
  find('.workshop-alert').text.should =~ /In-Person Workshop/
end

Then /^I should see a product alert for the online workshop$/ do
  find('.workshop-alert').text.should =~ /Online Workshop/
end

Then /^I should not see a product alert$/ do
  page.should_not have_css('.workshop-alert')
end

Then /^I should see a link to the in-person workshop$/ do
  workshop_name = find('.subject').text
  in_person_workshop = Workshop.in_person.find_by_name!(workshop_name)
  find('.workshop-alert a')[:href].should == workshop_path(in_person_workshop)
end

Then /^I should see a link to the online workshop$/ do
  workshop_name = find('.subject').text
  online_workshop = Workshop.online.find_by_name!(workshop_name)
  find('.workshop-alert a')[:href].should == workshop_path(online_workshop)
end
