Feature: Visitor view friendly URL
  In order to do SEO
  As a visitor
  I want to be able to see a friendly course and section URL

  Scenario: Visiting friendly course URL
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following course exists:
      | id | name                | start at | stop at  | price |
      | 42 | Test-Driven Haskell | 09:00:00 | 12:00:00 | 100   |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    Then I should be on the URL "/courses/42-test-driven-haskell"

  Scenario: Visiting friendly section URL
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following course exists:
      | name                | start at | stop at  | price |
      | Test-Driven Haskell | 09:00:00 | 12:00:00 | 100   |
    And the following section exists:
      | id | course                    | starts on     | ends on       |
      | 39 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    And "Ralph Bot" is teaching the section from "June 13, 2010" to "June 16, 2010"
    When I go to the home page
    And I follow "Test-Driven Haskell"
    Then I should be on the URL "/courses/1-test-driven-haskell"
