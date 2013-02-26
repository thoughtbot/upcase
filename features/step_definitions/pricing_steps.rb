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
