Given 'I create the following course:' do |course_fields|
  steps %{
    Given I go to the admin page
    And I follow "New Course"
  }
  And "I fill in the following:", course_fields
  steps %{
    And I press "Create Course"
    Then I see the successful course creation notice
  }
end

Then /^I should see the json for the public courses$/ do
  courses = Course.only_public
  JSON.parse(page.source).should == JSON.parse(courses_json(courses))
end

Then /^I should see the json for the public courses with the callback "([^"]*)"$/ do |callback|
  courses = Course.only_public
  matcher = /#{callback}\(([^\)]+)\)/
  matches = matcher.match(page.source)
  JSON.parse(matches[1]).should == JSON.parse(courses_json(courses))
end

Given /^a course "([^"]*)" is maked as unpublic$/ do |course_name|
  course = Course.find_by_name!(course_name)
  course.public = false
  course.save!
end

World(CoursesHelper)
