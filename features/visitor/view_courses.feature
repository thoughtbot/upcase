Feature: Viewing the courses page

  Scenario: Visitor can see product information
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
    When I go to the home page
    And I view all products
    Then I should see "Book 1"
    And I should see "Book 2"
    And I should see "Screencast 1"
    And I should see "Screencast 2"
    And I should see "Screencast 3"
    And I should see "Test-Driven Haskell"
