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
    And the following audiences exist:
      | name             | position |
      | Web Developer    | 1        |
      | Product Manager  | 2        |
    And the following course exists:
      | name                | position | audience              |
      | Test-Driven Go      | 1        | name: Product Manager |
      | Test-Driven Haskell | 1        | name: Web Developer   |
      | Test-Driven Erlang  | 2        | name: Web Developer   |
    When I go to the home page
    #Then I should see "Web Developer" before "Product Manager"
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

  Scenario: User can see books, screencasts and courses information
    Given today is June 17, 2010
    And the following course exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    And the following products exists:
      | name            |  product_type          |
      | Book 1          | book                   |
      | Book 2          | book and example app   |
      | Screencast 1    | screencast             |
      | Screencast 2    | screencast             |
      | Screencast 3    | screencast             |
    When I go to the new home page
    Then I should see element with id "product_tagline"
    And I should see element with id "product_sub_tagline"
    And I should see "Book 1"
    And I should see "Book 2"
    And I should see "Screencast 1"
    And I should see "Screencast 2"
    And I should see "Screencast 3"
    And I should see "Test-Driven Haskell"
