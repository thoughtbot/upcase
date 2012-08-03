Then '$email is registered for the $course_name course' do |email,course_name|
  registration = Registration.find_by_email!(email)
  course = Course.find_by_name!(course_name)
  registration.section.course.should == course
end

Given /^"([^"]*)" has registered for "([^"]*)"$/ do |email, course_name|
  steps %{
    When I go to the home page
    And I follow the link to the #{course_name} course
    And I follow the link to register for a section
    And I press "Proceed to checkout"
  }
end

Given /^"([^"]*)" has (\d+) registrations$/ do |course_name, count|
  course = Course.find_by_name!(course_name)
  section = course.sections.first
  count.to_i.times { create(:registration, section: section) }
end

Then /^I workshops is notified of my registration$/ do
  open_email("learn@thoughtbot.com", with_text: /just registered for/)
end

Then /^the registration for "([^"]*)" taking "([^"]*)" should be paid$/ do |email, course_name|
  course = Course.find_by_name!(course_name)
  course.registrations.find_by_email!(email).should be_paid
end

Then /^the registration for "([^"]*)" taking "([^"]*)" should not be paid$/ do |email, course_name|
  course = Course.find_by_name!(course_name)
  course.registrations.find_by_email!(email).should_not be_paid
end

Given /^a visitor named "([^"]*)" registered for "([^"]*)" on ([0-9-]+)$/ do |student_name, course_name, date|
  course = create(:course, name: course_name)
  section = create(:section, course: course, starts_on: date)
  create(:unpaid_registration, section: section, first_name: student_name)
end

When /^I mark "([^"]*)" as paid for "([^"]*)" on ([0-9-]+)$/ do |student_name, course_name, date|
  course = Course.find_by_name!(course_name)
  section = course.sections.find_by_starts_on!(date)
  registration = section.registrations.find_by_first_name!(student_name)

  visit edit_admin_course_section_path(course, section)
  within("#registration_#{registration.id}") do
    click_button 'Mark as paid'
  end
end

Then /^"([^"]*)" should be marked as paid for "([^"]*)" on ([0-9-]+)$/ do |student_name, course_name, date|
  course = Course.find_by_name!(course_name)
  section = course.sections.find_by_starts_on!(date)
  registration = section.registrations.find_by_first_name!(student_name)

  within("#registration_#{registration.id}") do
    page.should have_no_css("form")
  end
end
