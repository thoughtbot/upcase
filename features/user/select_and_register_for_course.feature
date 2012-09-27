Feature: Selecting a course and registering for it

  Scenario: A visitor signs into their account during registration
    Given the following user exists:
      | first_name | last_name | email        | password |
      | John       | Doe       | john@doe.com | password |
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I view all products
    And I follow "Test-Driven Haskell"
    And I follow "REGISTER FOR THIS WORKSHOP"
    And I follow "Sign in."
    And I fill in and submit the sign in form with "john@doe.com" and "password"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And "Email" should be filled in with "john@doe.com"
    And "First name" should be filled in with "John"
    And "Last name" should be filled in with "Doe"
    And I should see "Sign out"
