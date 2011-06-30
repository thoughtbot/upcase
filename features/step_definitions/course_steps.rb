Given 'I create the following course:' do |course_fields|
  steps %{
    Given I go to the admin page
    And I follow the link to create a new course
  }
  And "I fill in the following:", course_fields
  steps %{
    And I press the button to create a course
    Then I see the successful course creation notice
  }
end

Then /^I should see the json for the courses$/ do
  courses = Course.all
  JSON.parse(page.body).should == JSON.parse(courses.to_json)
end
