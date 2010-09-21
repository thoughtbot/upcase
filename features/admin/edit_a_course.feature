Feature: Editing a course

  Scenario Outline: Edit a course and clear a required field
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I blank the <field> field
    And I press the button to update a course
    Then I should see the admin header
    And I see the "can't be blank" error for the <field> field
  Examples:
    | field              |
    | course name        |
    | course description |
    | course price       |
    | start time         |
    | end time           |
    | location           |

  Scenario: Edit a course successfully
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow the link to edit the course "Test-Driven Sleeping"
    Then I should see the admin header
    When I fill in the course name with "Test-Driven Haskell"
    And I press the button to update a course
    Then I see the successful course update notice
    And I see the course named "Test-Driven Haskell"

  Scenario: Edit a course's FAQ
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following questions exist:
      | course                     | question           | answer          |
      | name: Test-Driven Sleeping | Do you wear pants? | Define "Pants." |
    When I go to the admin page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I fill in the question 2 with "Do I need a helmet?"
    And I fill in the answer 2 with "Of course."
    And I press the button to update a course
    Then I see the successful course update notice
    When I follow the link to edit the course "Test-Driven Sleeping"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |

  @javascript
  Scenario: Edit a course and add more than one FAQ
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow the link to edit the course "Test-Driven Sleeping"
    And I follow "Add Question"
    And I fill in the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
    And I press the button to update a course
    Then I see the successful course update notice
    When I follow the link to edit the course "Test-Driven Sleeping"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
