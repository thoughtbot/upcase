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
