Feature: Viewing the resources page

  Scenario: Resources do not exist
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And I am signed in as "mjones@example.com"
    And "mjones@example.com" has registered for "Test-Driven Haskell"
    When I am on the course resource page for "Test-Driven Haskell"
    Then I should not see "Resources"

  Scenario: Resources exist
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And the following resource exists:
      | course                    | name | url         |
      | name: Test-Driven Haskell | Foo  | example.com |
    And I am signed in as "mjones@example.com"
    And "mjones@example.com" has registered for "Test-Driven Haskell"
    When I am on the course resource page for "Test-Driven Haskell"
    Then I should see "Resources"

  Scenario: Faq does not exist
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And I am signed in as "mjones@example.com"
    And "mjones@example.com" has registered for "Test-Driven Haskell"
    When I am on the course resource page for "Test-Driven Haskell"
    Then I should not see "Frequently asked questions"

  Scenario: Faq exist
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And the following question exists:
      | course                    | question | answer   |
      | name: Test-Driven Haskell | How?     | This way |
    And I am signed in as "mjones@example.com"
    And "mjones@example.com" has registered for "Test-Driven Haskell"
    When I am on the course resource page for "Test-Driven Haskell"
    Then I should see "Frequently asked questions"
