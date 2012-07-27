Feature: Archive a course
  In order to be able to remove some course from the listing
  As an admin
  I would like to be able to archive a course

  Background:
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"

  Scenario: Archive course
    When I go to the home page
    Then I should see "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    Then the "Public" checkbox should be checked
    When I uncheck "Public"
    And I press "Save Course"
    Then I see the successful course update notice
    When I go to the home page
    Then I should not see "Test-Driven Sleeping"

  Scenario: Unarchive a course
    Given a non-public course "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    Then the "Public" checkbox should not be checked
    When I check "Public"
    And I press "Save Course"
    Then I see the successful course update notice
    When I go to the home page
    Then I should see "Test-Driven Sleeping"
