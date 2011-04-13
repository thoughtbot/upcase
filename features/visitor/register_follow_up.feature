Feature: Registering for a followup

  Scenario: Request a follow up
    Given today is June 17, 2010
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    When I go to the home page
    When I follow "Test-Driven Haskell"
    And I fill in "Want to be notified the next time we run this workshop?" with "foo@example.com"
    And I press "Submit"
    Then I should see "We will contact you when we schedule this course"
    When the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1235 | name: Test-Driven Haskell | July 17, 2010 | July 18, 2010 |
    Then "foo@example.com" receives a follow up email for "Test-Driven Haskell"

  Scenario: Request a follow up with invalid email
    Given today is June 17, 2010
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
    And the following section exists:
      | id   | course                    | starts on     | ends on       |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    When I go to the home page
    When I follow "Test-Driven Haskell"
    And I press "Submit"
    Then I should see "Could not save follow up. Please check your email address."
    When I go to the home page
    When I follow "Test-Driven Haskell"
    And I fill in "Want to be notified the next time we run this workshop?" with "yes!!"
    And I press "Submit"
    Then I should see "Could not save follow up. Please check your email address."
