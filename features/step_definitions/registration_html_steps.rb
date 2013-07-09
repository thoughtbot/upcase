When 'I fill in all of the workshop registration fields for "$email"' do |email|
  attributes = attributes_for(:purchase, email: email)
  fields = { "Name" => attributes[:name],
             "Email" => email,
             "Organization" => attributes[:organization],
             "Address 1" => attributes[:address1],
             "Address 2" => attributes[:address2],
             "City" => attributes[:city],
             "State / Province" => attributes[:state],
             "Postal / Zip Code" => attributes[:zip_code] }
  fields.each do |field, value|
    fill_in field, with: value
  end
end

When 'I fill in the required workshop registration fields for "$email"' do |email|
  attributes = attributes_for(:purchase)
  fields = { "Name" => attributes[:name],
             "Email" => email }
  fields.each do |field, value|
    fill_in field, with: value
  end
end

Then /^I should see that the email is invalid$/ do 
  within "#purchase_email_input" do
    page.should have_css(".inline-errors", text: "is invalid")
  end
end
