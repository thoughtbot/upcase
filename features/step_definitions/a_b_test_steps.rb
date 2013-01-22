When /^I view the "([^"]+)" product with (primary|alternate) pricing$/ do |product_name, pricing_scheme|
  product = Product.find_by_name!(product_name)

  visit product_path(product, product_workshop_pricing: pricing_scheme)
end

When /^I view the "([^"]+)" workshop with (primary|alternate) pricing$/ do |workshop_name, pricing_scheme|
  workshop = Workshop.find_by_name!(workshop_name)

  visit workshop_path(workshop, product_workshop_pricing: pricing_scheme)
end
