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
  create(:product, fulfillment_method: "fetch", name: product_name, product_type: "screencast")
end

When /^a video download product named "([^"]*)"$/ do |product_name|
  product = create(:product, fulfillment_method: "fetch", name: product_name, product_type: "screencast")
  create(:download, download_file_name: "test.txt", description: "test desc", product: product)
  create(:video, product: product)
end

Given /^there is a github product named "([^"]*)"$/ do |product_name|
  create(:product, fulfillment_method: "github", name: product_name, product_type: "book")
end
