Feature: Signing up

  Background:
    Given today is June 10, 2010
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    And I go to the home page

  Scenario: Signing up by registering for a class
    Given I follow the link to the Test-Driven Haskell course
    And I follow the link to register
    And I fill in the following:
      | First name            | Mike               |
      | Last name             | Jones              |
      | Email                 | mjones@example.com |
      | Password              | password           |
      | Password confirmation | password           |
    And I press "Proceed to checkout"
    Then "mjones@example.com" does not receive a set your password link
    And "mjones@example.com" does not receive a confirmation message
    When I follow the set your password link sent to "mjones@example.com"
    And I fill in the student's password with "testing"
    And I fill in the student's password confirmation with "testing"
    And I press the button to set the new password
    Then I see the successful sign in notice

  Scenario: Not entering valid user info
    Given I follow the link to the Test-Driven Haskell course
    And I follow the link to register
    And I press "Proceed to checkout"
    Then I see the failure User info invalid notice
    When I fill in the following:
      | First name            | Mike               |
      | Last name             | Jones              |
      | Email                 | mjones@example.com |
      | Password              | password           |
      | Password confirmation | password           |
    And I press "Proceed to checkout"
