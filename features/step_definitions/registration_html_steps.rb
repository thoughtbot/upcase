Then 'I see the course registration page for "$course_name"' do |course_name|
  page.should have_content(course_name)
  page.should have_content("Register")
end

Then /^I follow "([^"]*)" for the registration for "([^"]*)"$/ do |link_text, user_email|
  within "##{dom_id(Registration.find_by_email!(user_email))}" do
    click_link link_text
  end
end

When 'I fill in all of the course registration fields for "$email"' do |email|
  attributes = attributes_for(:registration_with_all_attributes, email: email)
  fields = { "First name" => attributes[:first_name],
             "Last name" => attributes[:last_name],
             "Email" => attributes[:email],
             "Billing email" => attributes[:billing_email],
             "Organization" => attributes[:organization],
             "Phone" => attributes[:phone],
             "Address 1" => attributes[:address1],
             "Address 2" => attributes[:address2],
             "City" => attributes[:city],
             "State" => attributes[:state],
             "Zip code" => attributes[:zip_code] }
  fields.each do |field, value|
    fill_in field, with: value
  end
end

When 'I fill in the required course registration fields for "$email"' do |email|
  attributes = attributes_for(:registration)
  fields = { "First name" => attributes[:first_name],
             "Last name" => attributes[:last_name],
             "Email" => email }
  fields.each do |field, value|
    fill_in field, with: value
  end
end
