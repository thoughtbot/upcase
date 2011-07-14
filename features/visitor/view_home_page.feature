Feature: Viewing Courses on the home page

  Scenario: No courses
    Given I go to the home page
    Then I should see "No courses are running at this time."

  Scenario: Scheduled Courses Appear with Dates
    Given today is June 10, 2010
    And the following course exists:
      | name                 | short_description |
      | Test-Driven Haskell  | short description |
      | Test-Driven Assembly | mov AL, 61h       |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    When I go to the home page
    Then I see "Test-Driven Haskell" is scheduled from "June 13, 2010" to "June 16, 2010"
    And I should see "short description"

  Scenario: Scheduled Courses Appear in Order
    Given today is June 10, 2010
    And the following course exists:
      | name                | position |
      | Test-Driven Go      | 3        |
      | Test-Driven Haskell | 1        |
      | Test-Driven Erlang  | 2        |
    When I go to the home page
    And I should see "Test-Driven Haskell" before "Test-Driven Erlang"
    And I should see "Test-Driven Erlang" before "Test-Driven Go"

  Scenario: Unscheduled Courses Appear without dates
    Given today is June 17, 2010
    And the following course exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    When I go to the home page
    Then I do not see the home page section from "June 13, 2010" to "June 16, 2010"
    And I should see "Test-Driven Haskell"
    And I should see "Short Description"
