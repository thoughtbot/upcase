Feature: Signing in

  Scenario: Signing in
    Given the following user exists:
      | email             | password       |
      | ralph@example.com | ralph_was_here |
    When I go to the sign in page
    And I fill in the session email with "ralph@example.com"
    And I fill in the session password with "ralph_was_here"
    And I press the button to sign in
    Then I should be on my account page

  Scenario: Admin Signing in
    Given the following admin exists:
      | email             | password       |
      | ralph@example.com | ralph_was_here |
    When I go to the sign in page
    And I fill in the session email with "ralph@example.com"
    And I fill in the session password with "ralph_was_here"
    And I press the button to sign in
    Then I should be on the admin page

  Scenario: Signing into a new account with GitHub
    When I go to the sign in page
    And I follow "with GitHub"
    Then I should be on my account page

  Scenario: Signing into an existing account with GitHub
    Given the following user exists:
      | email             | password       |
      | ralph@example.com | ralph_was_here |
    When I go to the sign in page
    And I follow "with GitHub"
    Then I should be on my account page
