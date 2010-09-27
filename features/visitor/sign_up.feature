Feature: Signing up

  Scenario: Signing up by registering for a class
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the external registration link
    And I fill in the following Chargify customer:
      | first name | last name | email              |
      | Mike       | Jones     | mjones@example.com |
    And I press the button to submit the Chargify form
    Then "mjones@example.com" receives a set your password link
    And "mjones@example.com" does not receive a confirmation message
    When I follow the set your password link sent to "mjones@example.com"
    And I fill in the student's password with "testing"
    And I fill in the student's password confirmation with "testing"
    And I press the button to set the new password
    And I follow the link to sign out
    And I follow the link to sign in
    And I fill in the login email with "mjones@example.com"
    And I fill in the login password with "testing"
    And I press the button to sign in
    Then I see the successful sign in notice
