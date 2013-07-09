Then '$email is registered for the $workshop_name workshop' do |email,workshop_name|
  registration = Purchase.find_by_email!(email)
  workshop = Workshop.find_by_name!(workshop_name)
  registration.purchaseable.workshop.should == workshop
end

Given /^"([^"]*)" has registered for "([^"]*)"$/ do |email, workshop_name|
  steps %{
    When I go to the products page
    And I follow the link to the #{workshop_name} workshop
    And I follow the link to register for a section
    And I press "Submit Payment"
  }
end

Then /^I workshops is notified of my registration$/ do
  open_email("learn@thoughtbot.com", with_text: /just registered for/)
end

Then /^the registration for "([^"]*)" taking "([^"]*)" should be paid$/ do |email, workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  workshop.registrations.find_by_email!(email).should be_paid
end

Then /^the registration for "([^"]*)" taking "([^"]*)" should not be paid$/ do |email, workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  workshop.registrations.find_by_email!(email).should_not be_paid
end
