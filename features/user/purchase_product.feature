Feature: Purchase a Product
  As a user
  I want to purchase a product
  So that I can give you money

  Background:
    Given a video download product named "Test Fetch"

  @selenium @allow-rescue
  Scenario: A user purchases a product with paypal
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I go to the products page
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
    Then I should see a video
    And I should see the download links for video with id "1194803"
    And I should see a list of other products

  @selenium @allow-rescue
  Scenario: A user purchases a product with stripe with existing credit card
    Given I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    And I have an existing credit card
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I pay with existing credit card
    Then I should see "Thank you"
