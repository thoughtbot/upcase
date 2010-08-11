Feature: Scheduling a new course

  @wip
  Scenario: Adding a new section for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I press the button to re-run a course
    Then I see the successful section creation notice
    When I follow the link to view the sessions for "Test-Driven Sleeping"
    Then I see the session from "June 14, 2010" to "June 17, 2010"
