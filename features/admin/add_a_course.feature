Feature: Adding a course

  @wip
  Scenario: Add a course with blank required fields
    Given I am signed in as an admin
    When I go to the home page
    And I follow the link to create a new course
    And I press the button to create a course
    Then I see the "can't be blank" error for the following fields:
      | name        |
      | description |
      | starts on   |
      | ends on     |
      | location    |

  @wip
  Scenario: Add a course
