Feature: A/B testing different headlines

  Background:
    Given today is June 10, 2010
    And the following course exists:
      | name                 | short_description |
      | Test-Driven Haskell  | short description |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |

  Scenario: Get better faster copy
    Given I go to the home page with the "get_better_faster" alternative for the "landing_page_headline" experiment
    Then I should see "Get better, faster in our small, hands-on workshops"
    And KISSmetrics receives the following properties:
      | property              | value             |
      | landing_page_headline | get_better_faster |

  Scenario: Learn from experts copy
    Given I go to the home page with the "learn_from_experts" alternative for the "landing_page_headline" experiment
    Then I should see "Learn from experts."
    And I should see "Become one yourself."
    And KISSmetrics receives the following properties:
      | property              | value              |
      | landing_page_headline | learn_from_experts |
