Given 'I create the following course:' do |course_fields|
  steps %{
    Given I go to the admin page
    And I follow "New Course"
  }
  And "I fill in the following:", course_fields
  steps %{
    And I press the button to create a course
    Then I see the successful course creation notice
  }
end

Then /^I should see the json for the courses$/ do
  courses = Course.all
  JSON.parse(page.source).should == JSON.parse(courses_json(courses))
end

Then /^I should see the json for the courses with the callback "([^"]*)"$/ do |callback|
  courses = Course.all
  matcher = /#{callback}\(([^\)]+)\)/
  matches = matcher.match(page.body)
  JSON.parse(matches[1]).should == JSON.parse(courses_json(courses))
end

World(CoursesHelper)
