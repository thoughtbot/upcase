Feature: Purchase a Product
  As a user
  I want to purchase a product
  So that I can give you money

  Background:
    Given a video download product named "Test Fetch"

  Scenario: A visitor signs into their account through checkout
    Given the following user exists:
      | first_name | last_name | email        | password |
      | John       | Doe       | john@doe.com | password |
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    And I follow "Sign in."
    And I fill in and submit the sign in form with "john@doe.com" and "password"
    Then I should see the checkout form
    And "Email" should be filled in with "john@doe.com"
    And "Name" should be filled in with "John Doe"
    And I should see "Sign out"

  @selenium
  Scenario: A user purchases a product with paypal
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Your Company"
    Then I should see "$50"
    When I pay using Paypal
    And I submit the Paypal form
    Then I should see that product "Test Fetch" is successfully purchased
    And I should see "test.txt"
    And I should see "test desc"
    And I should see the link to the video page
    When "mr.the.plague@example.com" opens the email
    Then they should not see "You can also create a user account" in the email body
    When I follow "Watch or download video"
    Then I should see a video
    And I should see the download links for video with id "1194803"
    And I should see a list of other products

  @selenium
  Scenario: A user purchases a product with stripe with existing credit card
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I have an existing credit card
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I pay with existing credit card
    Then I should see "Thank you"
