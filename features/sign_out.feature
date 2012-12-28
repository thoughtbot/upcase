Feature: Signing out

  Scenario: Signin out as an admin
    Given I am signed in as an admin
    And I go to the my account page
    When I follow "Sign out"
    Then I should be on the sign in page
