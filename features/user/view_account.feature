Feature: Viewing my own account information

  Scenario: View my account information
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I have 3 purchases
    And I have 3 workshops
    When I follow "My Account"
    Then I should see the edit account form
    And I should see "Your purchases"
    And I should see my 3 purchases
    And I should see my 3 workshops

  Scenario: View my account information with no purchases or workshops
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I follow "My Account"
    Then I should not see "Your purchases"
    And I should not see "Products"
    And I should not see "Workshops"

  Scenario: Edit my account information
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I follow "My Account"
    When I fill in "Github username" with "dhh"
    And I press "Update account"
    Then "Github username" should be filled in with "dhh"
