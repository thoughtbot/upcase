When /^I fill in the (.*) address$/ do |location_name|
  location = location_for(location_name)

  fill_in 'Address', with: location[:address]
  fill_in 'City', with: location[:city]
  fill_in 'State', with: location[:state]
  fill_in 'Zip', with: location[:zip]
end
