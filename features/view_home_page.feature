Feature: Viewing Courses on the home page

  Scenario: Scheduled Courses Appear with Dates
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    Then I see the home page section from "June 13, 2010" to "June 16, 2010"
    And I should see "Test-Driven Haskell"

  @wip
  Scenario: Unscheduled Courses Appear without dates
    Given today is June 17, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    Then I do not see the home page section from "June 13, 2010" to "June 16, 2010"
    And I should see "Test-Driven Haskell"
