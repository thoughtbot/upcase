Feature: Scheduling a new course

  Scenario: Adding a new section for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Albert Einstein"
    And I press the button to re-run a course
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    Then I see that "Albert Einstein" is teaching

  @wip
  Scenario: Adding a new section without filling in the teacher

  @wip
  Scenario: Adding a new section and a new teacher
    # must populate the teachers.gravatar_hash field
 
  @wip
  Scenario: Adding a new section as a student
