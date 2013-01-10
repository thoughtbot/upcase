Feature: Editing a workshop

  Scenario Outline: Edit a workshop and clear a required field
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I blank the <field> field
    And I press "Save Workshop"
    And I see the "can't be blank" error for the <field> field
  Examples:
    | field                |
    | workshop name        |
    | workshop description |
    | workshop price       |
    | start time           |
    | end time             |

  Scenario: Edit a workshop successfully
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    When I fill in the workshop name with "Test-Driven Haskell"
    And I press "Save Workshop"
    Then I see the successful workshop update notice
    And I see the workshop named "Test-Driven Haskell"

  Scenario: Edit a workshop's FAQ
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"
    And the following questions exist:
      | workshop                   | question           | answer          |
      | name: Test-Driven Sleeping | Do you wear pants? | Define "Pants." |
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I fill in the question 2 with "Do I need a helmet?"
    And I fill in the answer 2 with "Of course."
    And I press "Save Workshop"
    Then I see the successful workshop update notice
    When I follow "Test-Driven Sleeping"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |

  @selenium
  Scenario: Edit a workshop and add more than one FAQ
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I follow "Add Question"
    And I fill in the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
    And I press "Save Workshop"
    Then I see the successful workshop update notice
    When I follow "Test-Driven Sleeping"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
