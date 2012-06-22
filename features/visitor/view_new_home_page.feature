Feature: Viewing Courses on the home page

  Scenario: Public Courses Appear in Order
    Given today is June 10, 2010
    And the following courses exist:
      | name                 | position | short_description | public |
      | Test-Driven Haskell  | 4        | short description | true   |
      | Test-Driven Assembly | 2        | mov AL, 61h       | false  |
      | Test-Driven Go       | 3        | short description | true   |
      | Test-Driven Erlang   | 1        | short description | true   |
    When I go to the new home page
    Then I see the course named "Test-Driven Haskell"
    And I should see "short description"
    Then I should not see the course named "Test-Driven Assembly"
    And I should see "Test-Driven Erlang" before "Test-Driven Go"
    And I should see "Test-Driven Go" before "Test-Driven Haskell"

  Scenario: Visitor can see books, screencasts and courses information
    Given today is June 17, 2010
    And the following course exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    And the following products exists:
      | name            | product_type           |
      | Book 1          | book                   |
      | Book 2          | book and example app   |
      | Screencast 1    | screencast             |
      | Screencast 2    | screencast             |
      | Screencast 3    | screencast             |
    When I go to the new home page
    Then I should see "Book 1"
    And I should see "Book 2"
    And I should see "Screencast 1"
    And I should see "Screencast 2"
    And I should see "Screencast 3"
    And I should see "Test-Driven Haskell"

  Scenario: Visitor can see articles
    Given there is an article
    When I go to the new home page
    Then I see the article
