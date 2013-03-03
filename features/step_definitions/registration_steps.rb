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

Given /^"([^"]*)" has (\d+) registrations$/ do |workshop_name, count|
  workshop = Workshop.find_by_name!(workshop_name)
  section = workshop.sections.first
  count.to_i.times { create(:free_purchase, purchaseable: section) }
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

Given /^a visitor named "([^"]*)" registered for "([^"]*)" on ([0-9-]+)$/ do |student_name, workshop_name, date|
  workshop = create(:workshop, name: workshop_name)
  section = create(:section, workshop: workshop, starts_on: date)
  create(:unpaid_registration, section: section, first_name: student_name)
end

When /^I mark "([^"]*)" as paid for "([^"]*)" on ([0-9-]+)$/ do |student_name, workshop_name, date|
  workshop = Workshop.find_by_name!(workshop_name)
  section = workshop.sections.find_by_starts_on!(date)
  registration = section.registrations.find_by_first_name!(student_name)

  visit edit_admin_workshop_section_path(workshop, section)
  within("#registration_#{registration.id}") do
    click_button 'Mark as paid'
  end
end

Then /^"([^"]*)" should be marked as paid for "([^"]*)" on ([0-9-]+)$/ do |student_name, workshop_name, date|
  workshop = Workshop.find_by_name!(workshop_name)
  section = workshop.sections.find_by_starts_on!(date)
  registration = section.registrations.find_by_first_name!(student_name)

  within("#registration_#{registration.id}") do
    page.should have_no_css("form")
  end
end
