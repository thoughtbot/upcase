Feature: Viewing the courses page

  Scenario: Visitor views products and courses
    Given today is June 17, 2010
    And the following course exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    And the following products exists:
      | name            | product_type           |
      | Book 1          | book                   |
      | Book 2          | book                   |
      | Video 1         | video                  |
      | Video 2         | video                  |
      | Video 3         | video                  |
    When I go to the home page
    And I view all products
    Then I should see "Book 1"
    And I should see "Book 2"
    And I should see "Video 1"
    And I should see "Video 2"
    And I should see "Video 3"
    And I should see "Test-Driven Haskell"

  Scenario: Visitor can see course information
    Given the following course exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    When I go to the home page
    And I view all products
    And I follow "Test-Driven Haskell"
    Then the meta description should be "Short Description"
    And the page title should be "Test-Driven Haskell: a course from thoughtbot"
