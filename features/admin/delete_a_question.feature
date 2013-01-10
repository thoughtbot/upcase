Feature: Removing a question

  Scenario: Delete a workshop's FAQ
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
    And I follow the question remove link within the "Do you wear pants?" question
    Then I see the following questions:
      | question            | answer     |
      | Do I need a helmet? | Of course. |
