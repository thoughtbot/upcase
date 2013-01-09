@selenium
Feature: KISSmetrics tracks important events

  Scenario: Workshop registration
    Given an audience exists with a name of "Developers"
    And the following workshop exists:
      | name                |  audience         | individual_price |
      | Test-Driven Haskell |  name: Developers | 200              |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    Then KISSmetrics receives the "Viewed Product" event with:
      | Product Name | Test-Driven Haskell |
    When I follow "Register for this Workshop"
    Then KISSmetrics receives the "Checkout" event with:
      | Product Name | Test-Driven Haskell |
      | Order Total  | 200                 |
    When I fill in the required workshop registration fields for "carlos@santana.com"
    And I press "Submit Payment"
    Then KISSmetrics receives the "Submit Payment" event for "carlos@santana.com" over HTTP with:
      | Product Name | Test-Driven Haskell |
      | Order Total  | 200                 |
    And KISSmetrics receives the "Purchased" event for "carlos@santana.com" over HTTP with:
      | Product Name | Test-Driven Haskell |
      | Order Total  | 200                 |

  Scenario: Purchasing a product with paypal
    Given the following book product exists:
      | name        | individual_price |
      | Test Kiss   | 15               |
    When I go to the home page
    And I view all products
    And I follow "Test Kiss"
    Then KISSmetrics receives the "Viewed Product" event with:
      | Product Name | Test Kiss |
    When I follow "Purchase for Yourself"
    Then KISSmetrics receives the "Checkout" event with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |
    When I pay using Paypal
    Then KISSmetrics receives the "Submit Payment" event for "mr.the.plague@example.com" over HTTP with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |
    When I submit the Paypal form
    Then KISSmetrics receives the "Purchased" event for "mr.the.plague@example.com" over HTTP with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |

  Scenario: Purchasing a product with stripe
    Given the following book product exists:
      | name        | individual_price |
      | Test Kiss   | 15               |
    When I go to the home page
    And I view all products
    And I follow "Test Kiss"
    Then KISSmetrics receives the "Viewed Product" event with:
      | Product Name | Test Kiss |
    When I follow "Purchase for Yourself"
    Then KISSmetrics receives the "Checkout" event with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |
    When I pay using Stripe
    Then KISSmetrics receives the "Submit Payment" event for "mr.the.plague@example.com" over HTTP with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |
    And KISSmetrics receives the "Purchased" event for "mr.the.plague@example.com" over HTTP with:
      | Product Name | Test Kiss |
      | Order Total  | 15        |
    And I should see that product "Test Kiss" is successfully purchased

  Scenario: Visitor requests a follow up
    Given today is June 17, 2010
    And the following workshop exists:
      | name                |
      | Test-Driven Haskell |
    And the following section exists:
      | id   | workshop                  | starts on     | ends on       |
      | 1235 | name: Test-Driven Haskell | July 17, 2010 | July 18, 2010 |
    When I go to the home page
    And I view all products
    When I follow "Test-Driven Haskell"
    And I press "Submit"
    Then KISSmetrics does not receive the "Followed up" event
    When I fill in "follow_up_email" with "foo@example.com"
    And I press "Submit"
    Then KISSmetrics receives the "Requested Followup" event with:
      | Course Name | Test-Driven Haskell |
