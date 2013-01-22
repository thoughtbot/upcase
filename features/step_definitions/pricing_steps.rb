Then /^I should see that the (individual|company) product price is "([^"]+)"$/ do |variant, price|
  find(".#{variant}-purchase span").should have_content price
end

Then /^I should see that the individual workshop price is "([^"]+)"$/ do |price|
  is_in_person = page.has_css?(".section-location")

  if is_in_person
    find(".section-location span").should have_content price
  else
    find(".individual-purchase span").should have_content price
  end
end

Then /^I should see that the company workshop price is "([^"]+)"$/ do |price|
  find(".company-purchase span").should have_content price
end

Then /^the product purchase variants should be (primary|alternate)$/ do |purchase_variant|
  individual_variant = find('.individual-purchase .license a')[:href]
  company_variant = find('.company-purchase .license a')[:href]

  if purchase_variant == 'primary'
    individual_variant.should include '?variant=individual'
    company_variant.should include '?variant=company'
  else
    individual_variant.should include '?variant=alternate_individual'
    company_variant.should include '?variant=alternate_company'
  end
end
