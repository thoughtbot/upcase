Feature: Viewing the workshops page

  Scenario: Visitor views products and workshops
    Given today is June 17, 2010
    And the following workshop exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    And the following products exists:
      | name    | product_type |
      | Book 1  | book         |
      | Book 2  | book         |
      | Video 1 | video        |
      | Video 2 | video        |
      | Video 3 | video        |
    When I go to the home page
    And I view all products
    Then I should see "Book 1"
    And I should see "Book 2"
    And I should see "Video 1"
    And I should see "Video 2"
    And I should see "Video 3"
    And I should see "Test-Driven Haskell"

  Scenario: Visitor can see workshop information
    Given the following workshop exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    When I go to the home page
    And I view all products
    And I follow "Test-Driven Haskell"
    Then the meta description should be "Short Description"
    And the page title should be "Test-Driven Haskell: a workshop from thoughtbot"

  Scenario: Visitor sees online and in-person workshops
    Given the following workshops exist:
      | name              | online |
      | In-Person Haskell | false  |
      | Online Haskell    | true   |
    When I go to the home page
    And I view all products
    Then I should see that "In-Person Haskell" is an in-person workshop
    And I should see that "Online Haskell" is an online workshop
