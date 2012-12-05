Feature: KISSmetrics tracks registration events

  @selenium @allow-rescue
  Scenario: KISSmetrics events fire correctly on paid section
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                |  audience         |
      | Test-Driven Haskell |  name: Developers |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    And KISSmetrics receives the "Started Purchase" event with:
      | Product Name | Test-Driven Haskell |
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Submit Payment"
    Then KISSmetrics receives the "Submitted Purchase" event for "carlos@santana.com" over HTTP with:
      | Product Name | Test-Driven Haskell |

  @selenium
  Scenario: User registers for a free section
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 0                |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then KISSmetrics receives the "Started Purchase" event with:
      | Product Name | Test-Driven Haskell |
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Submit Payment"
    Then KISSmetrics receives the "Submitted Purchase" event for "carlos@santana.com" over HTTP with:
      | Product Name | Test-Driven Haskell |
