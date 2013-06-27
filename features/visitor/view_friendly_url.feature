Feature: Visitor view friendly URL
  In order to do SEO
  As a visitor
  I want to be able to see a friendly workshop and section URL

  Scenario: Visiting friendly workshop URL
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following workshop exists:
      | id | name                | individual_price |
      | 42 | Test-Driven Haskell | 100              |
    When I go to the workshop page of "Test-Driven Haskell"
    Then I should be on the URL "/workshops/42-test-driven-haskell"

  Scenario: Visiting friendly section URL
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following workshop exists:
      | name                | individual_price |
      | Test-Driven Haskell | 100              |
    And the following section exists:
      | id | workshop                  | starts on     | ends on       |
      | 39 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    And "Ralph Bot" is teaching the section from "June 13, 2010" to "June 16, 2010"
    When I go to the workshop page of "Test-Driven Haskell"
    Then I should be on the URL "/workshops/1-test-driven-haskell"
