Feature: Viewing my own account information

  Scenario: View my account information
    Given I have signed up with "user@example.com"
    And I have 3 paid purchases
    And I have 3 paid workshops
    When I sign in with "user@example.com"
    Then I should see the edit account form
    And I should see "Your purchases"
    And I should see my 3 purchases
    And I should see my 3 workshops

  Scenario: View my account information with no purchases or workshops
    Given I have signed up with "user@example.com"
    When I sign in with "user@example.com"
    Then I should not see "Your purchases"
    And I should not see "Products"
    And I should not see "Workshops"

  @selenium
  Scenario: View my account information with only unpaid purchases
    Given a video download product named "Ruby Science: video edition"
    And I have signed up with "user@example.com"
    When I sign in with "user@example.com"
    And I view the product "Ruby Science: video edition"
    And I follow "Purchase for Yourself"
    And I pay using Paypal
    And I go to my account page
    Then I should not see "Your purchases"
    And I should not see "Products"
    And I should not see "Workshops"

  @selenium
  Scenario: View my account information with paid and unpaid purchases
    Given a video download product named "Ruby Science: video edition"
    And a video download product named "Vim for Emacs users"
    And I have signed up with "user@example.com"
    When I sign in with "user@example.com"
    And I view the product "Ruby Science: video edition"
    And I follow "Purchase for Yourself"
    And I pay using Paypal
    And I view the product "Vim for Emacs users"
    And I follow "Purchase for Yourself"
    And I pay using Paypal
    And I submit the Paypal form
    And I go to my account page
    Then I should see "Your purchases"
    And I should see "Products"
    And I should see "Vim for Emacs users"
    And I should not see "Ruby Science: video edition"

  Scenario: Edit my account information
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I fill in "Github username" with "dhh"
    And I press "Update account"
    Then "Github username" should be filled in with "dhh"
