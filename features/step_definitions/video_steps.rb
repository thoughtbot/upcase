Given /^the video with wistia id "([^"]*)" exists for "([^"]*)"$/ do |wistia_id, product_name|
  product = Product.find_by_name!(product_name)
  create(:video, wistia_id: wistia_id, purchaseable: product)
end
