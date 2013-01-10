Feature: Archive a workshop
  In order to be able to remove some workshop from the listing
  As an admin
  I would like to be able to archive a workshop

  Background:
    Given I am signed in as an admin
    And a workshop exists with a name of "Test-Driven Sleeping"

  Scenario: Archive workshop
    When I go to the home page
    And I view all products
    Then I should see "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    Then the "Public" checkbox should be checked
    When I uncheck "Public"
    And I press "Save Workshop"
    Then I see the successful workshop update notice
    When I go to the home page
    And I view all products
    Then I should not see "Test-Driven Sleeping"

  Scenario: Unarchive a workshop
    Given a non-public workshop "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    Then the "Public" checkbox should not be checked
    When I check "Public"
    And I press "Save Workshop"
    Then I see the successful workshop update notice
    When I go to the home page
    And I view all products
    Then I should see "Test-Driven Sleeping"
