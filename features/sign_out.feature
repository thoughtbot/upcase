Feature: Signing out

  Scenario: Signin out as an admin
    Given I am signed in as an admin
    When I follow "Sign out"
    Then I see the successful sign out notice
