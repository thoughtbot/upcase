Given /^the a download exists with file name "([^"]*)" and description "([^"]*)" for "([^"]*)"$/ do |download_file_name, description, product_name|
  product = Product.find_by_name!(product_name)
  create(:download, 
    download_file_name: download_file_name, 
    description: description, 
    purchaseable: product)
end
