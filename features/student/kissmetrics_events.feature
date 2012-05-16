Feature: KISSmetrics tracks registration events

  @selenium @allow-rescue
  Scenario: KISSmetrics events fire correctly on paid section
    Given today is June 10, 2010
    And time is unfrozen
    And an audience exists with a name of "Developers"
    And the following course exists:
      | name                |  audience         |
      | Test-Driven Haskell |  name: Developers |
    And the following section exists:
      | starts_on  | ends_on    | course                    |
      | 2011-01-13 | 2011-01-15 | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    And KISSmetrics receives the "Started Registration" event with:
      | Course Name | Test-Driven Haskell |
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then KISSmetrics receives the "Submitted Registration" event for "carlos@santana.com" over HTTP with:
      | Course Name | Test-Driven Haskell |

  @selenium
  Scenario: User registers for a free section
    Given today is June 10, 2010
    And time is unfrozen
    And an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 0     |
    And the following section exists:
      | starts_on  | ends_on    | course                    |
      | 2011-01-13 | 2011-01-15 | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then KISSmetrics receives the "Started Registration" event with:
      | Course Name | Test-Driven Haskell |
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then KISSmetrics receives the "Submitted Registration" event for "carlos@santana.com" over HTTP with:
      | Course Name | Test-Driven Haskell |
