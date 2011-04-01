Feature: Signing in

  Scenario: Signing in
    Given the following email confirmed user exists:
      | email             | password       | password confirmation |
      | ralph@example.com | ralph_was_here | ralph_was_here        |
    When I go to the home page
    And I go to the sign in page
    And I fill in the session email with "ralph@example.com"
    And I fill in the session password with "ralph_was_here"
    And I press the button to sign in
    Then I see the successful sign in notice
    And I should be on the home page

  Scenario: Admin Signing in
    Given the following email confirmed user exists:
      | email             | password       | password confirmation | admin |
      | ralph@example.com | ralph_was_here | ralph_was_here        | true  |
    When I go to the home page
    And I go to the sign in page
    And I fill in the session email with "ralph@example.com"
    And I fill in the session password with "ralph_was_here"
    And I press the button to sign in
    Then I see the successful sign in notice
    And I should be on the admin page
