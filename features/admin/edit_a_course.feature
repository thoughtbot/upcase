Feature: Editing a course

  @wip
  Scenario: Add a course with blank required fields
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I blank the course name field
    And I blank the course description field
    And I blank the course price field
    And I blank the start time field
    And I blank the end time field
    And I press the button to update a course
    Then I see the "can't be blank" error for the following fields:
      | name        |
      | description |
      | price       |
      | starts on   |
      | ends on     |
      | location    |

  @wip
  Scenario: Edit a course successfully
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I fill in the course name with "Test-Drive Haskell"
    And I press the button to update a course
    Then I see the successful course update notice
    And I see the course named "Test-Driven Haskell"

  @wip
  Scenario: Edit a course's FAQ
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I fill in the question 2 with "Do I need a helmet?"
    And I fill in the answer 2 with "Of course."
    And I press the button to create a course
    Then I see the successful course update notice
    And I see the course named "Test-Driven Haskell"
