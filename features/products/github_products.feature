Feature: Purchase a github based product
  As a user
  I want to purchase github products
  So that I can give you money

  @selenium
  Scenario: A user purchases a product with a reader
    Given github is stubbed
    And there is a github product named "Test GitHub"
    And I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I go to the products page
    And I follow "Test GitHub"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    And I should see "1st Reader"
    When I add a reader
    When I pay using Paypal
    And I submit the Paypal form
    Then I should see that product "Test GitHub" is successfully purchased
    And the site should know my github username

  @selenium
  Scenario: A user attempts to purchase a product without a reader
    Given github is stubbed
    And there is a github product named "Test GitHub"
    And I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I go to the products page
    And I follow "Test GitHub"
    And I follow "Purchase for Yourself"
    When I press "Submit Payment"
    Then I should see a github username error

  Scenario: A user with github username purchases a product with a reader
    Given the following user exists:
      | first_name | last_name | email        | password | github_username |
      | John       | Doe       | john@doe.com | password | thoughtbot      |
    And there is a github product named "Test GitHub"
    When I go to the products page
    And I follow "Test GitHub"
    And I follow "Purchase for Yourself"
    And I follow "Sign in."
    And I fill in and submit the sign in form with "john@doe.com" and "password"
    Then the first reader should be my github username
