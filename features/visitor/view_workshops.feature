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
    When I view all products
    Then I should see the cover for "Book 1"
    And I should see the cover for "Book 2"
    And I should see "Video 1"
    And I should see "Video 2"
    And I should see "Video 3"
    And I should see "Test-Driven Haskell"

  Scenario: Visitor can see workshop information
    Given the following workshop exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    When I view all products
    And I follow "Test-Driven Haskell"
    Then the meta description should be "Short Description"
    And the page title should be "Test-Driven Haskell: a workshop from thoughtbot"
    And I should see a product title of "Short Description"

  Scenario: Visitor sees online and in-person workshops
    Given the following workshops exist:
      | name              | online |
      | In-Person Haskell | false  |
      | Online Haskell    | true   |
    When I view all products
    Then I should see that "In-Person Haskell" is an in-person workshop
    And I should see that "Online Haskell" is an online workshop

  Scenario: Visitor sees a link to group purchase for online workshops
    Given today is January 11, 2013
    And the following workshop exists:
      | name            | online |
      | Online Workshop | true   |
    And the following section exists:
      | workshop              | starts_on    |
      | name: Online Workshop | 2013-01-12   |
    When I view all products
    And I follow "Online Workshop"
    Then I should see "Purchase for Your Company"

  Scenario: Visitor does not see a link to group purchase for in-person workshops
    Given today is January 11, 2013
    And the following workshop exists:
      | name               | online |
      | In-Person Workshop | false  |
    And the following section exists:
      | workshop                 | starts_on    |
      | name: In-Person Workshop | 2013-01-12   |
    When I view all products
    And I follow "In-Person Workshop"
    Then I should not see "Purchase for Your Company"
