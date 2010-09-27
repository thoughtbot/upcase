Feature: Viewing a section

  Scenario: Admin should see resources
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following resources exist:
      | course                    | name           | url                       |
      | name: Test-Driven Haskell | The google     | http://www.google.com     |
      | name: Test-Driven Haskell | The thoughtbot | http://www.thoughtbot.com |
    And the following section exists:
      | course                    | starts on     | ends on       | chargify id |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And I am signed in as an admin
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    Then I see the course resource page for "Test-Driven Haskell"
    And the resource "The google" links to "http://www.google.com"
    And the resource "The thoughtbot" links to "http://www.thoughtbot.com"
