Feature: Viewing my own account information

  Scenario: View my account information
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I have "3" purchases
    When I follow "My Account"
    Then I should see the edit account form
    And I should see my "3" purchases

  Scenario: View my account information with no purchases
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I follow "My Account"
    Then I should not see "My Purchases"

  Scenario: Edit my account information
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I follow "My Account"
    When I fill in "Github username" with "dhh"
    And I press "Update account"
    Then "Github username" should be filled in with "dhh"
