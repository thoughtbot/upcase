Feature: Registering for a followup

  Scenario: Request a follow up
    Given today is June 17, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    When I follow "Test-Driven Haskell"
    And I fill in "Want to be notified when this course is scheduled?" with "foo@example.com"
    And I press "Submit"
    Then I should see "We will contact you when we schedule this course"
    When the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1235 | name: Test-Driven Haskell | July 17, 2010 | July 18, 2010 | 1234        |
    Then "foo@example.com" receives a follow up email for "Test-Driven Haskell"

  Scenario: Request a follow up
    Given today is June 17, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    When I follow "Test-Driven Haskell"
    And I press "Submit"
    Then I should see "Could not save follow up. Please check your email address."
