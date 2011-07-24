Feature: Signing out

  Scenario: Signin out as an admin
    Given I am signed in as an admin
    When I follow "Sign out"
    Then I should be on the sign in page
