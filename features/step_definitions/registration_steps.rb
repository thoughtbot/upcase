Then '$email is registered for the $course_name course' do |email,course_name|
  user = User.find_by_email!(email)
  course = Course.find_by_name!(course_name)
  section = user.sections.detect {|s| s.course == course}
  section.should_not be_nil, "expected #{email} to be registered for #{course_name}"
end

Given /^"([^"]*)" has registered for "([^"]*)"$/ do |email, course_name|
  steps %{
    When I go to the home page
    And I follow the link to the #{course_name} course
    And I follow the external registration link
    And I fill in the following Chargify customer:
      | first name | last name | email    |
      | Mike       | Jones     | #{email} |
    And I press the button to submit the Chargify form
    Then I am signed in as:
      | first name | last name | email    |
      | Mike       | Jones     | #{email} |
  }
end

Given /^"([^"]*)" has (\d+) registrations$/ do |course_name, count|
  course = Course.find_by_name!(course_name)
  section = course.sections.first
  count.to_i.times { Factory(:registration, :section => section) }
end
