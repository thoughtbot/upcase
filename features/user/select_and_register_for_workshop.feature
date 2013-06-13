Feature: Selecting a workshop and registering for it

  Scenario: A visitor signs into their account during registration
    Given the following user exists:
      | first_name | last_name | email        | password |
      | John       | Doe       | john@doe.com | password |
    And the following workshop exists:
      | name                |
      | Test-Driven Haskell |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the workshop page of "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    And I follow "Sign in."
    And I fill in and submit the sign in form with "john@doe.com" and "password"
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And "Email" should be filled in with "john@doe.com"
    And "Name" should be filled in with "John Doe"
    And I should see "Sign out"
