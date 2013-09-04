Feature: Signing in

  Scenario: Signing in
    Given the following user exists:
      | email             | password       |
      | ralph@example.com | ralph_was_here |
    When I go to the sign in page
    And I fill in the session email with "ralph@example.com"
    And I fill in the session password with "ralph_was_here"
    And I press the button to sign in
    Then I should be on my dashboard

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
    Given github is stubbed
    When I go to the sign in page
    And I follow "with GitHub"
    Then I should be on my dashboard
    And the site should have my github information
    And I should have no password field

  Scenario: Signing up for a new account with GitHub
    Given github is stubbed
    When I go to the sign up page
    And I follow "with GitHub"
    Then I should be on my dashboard
    And the site should have my github information
    And I should have no password field

  Scenario: Signing into an existing account with GitHub
    Given the following user exists:
      | email             | password       | auth_provider | auth_uid |
      | ralph@example.com | ralph_was_here | github        | 1        |
    When I go to the sign in page
    And I follow "with GitHub"
    Then I should be on my dashboard
    And I should have no password field
