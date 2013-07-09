Feature: Purchase a github based product
  As a user
  I want to purchase github products
  So that I can give you money

  Scenario: A user with github username purchases a product with a reader
    Given the following user exists:
      | name     | email        | password | github_username |
      | John Doe | john@doe.com | password | thoughtbot      |
    And there is a github product named "Test GitHub"
    When I visit the product page for "Test GitHub"
    And I follow "Purchase for Yourself"
    And I follow "Sign in."
    And I fill in and submit the sign in form with "john@doe.com" and "password"
    Then the first reader should be my github username
