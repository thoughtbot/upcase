Feature: Scheduling a new workshop

  Scenario: Removing a followup
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"
    And the following follow up exists:
      | workshop                   | email           |
      | name: Test-Driven Sleeping | foo@example.com |
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I follow the remove link for the "foo@example.com" follow up
    And I press "Save Workshop"
    And I go to the admin page
    And I follow "Test-Driven Sleeping"
    Then I should not see the "foo@example.com" follow up
