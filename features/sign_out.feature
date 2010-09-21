Feature: Signing out

  Scenario: Signing out as a student
    Given I am signed in as a student
    When I follow the link to sign out
    Then I see the successful sign out notice

  Scenario: Signin out as an admin
    Given I am signed in as an admin
    When I follow the link to sign out
    Then I see the successful sign out notice
