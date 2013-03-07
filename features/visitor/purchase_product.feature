Feature: Purchase a Product
  As a visitor
  I want to purchase a product
  So that I can give you money

  Background:
    Given the following products exist:
      | name         | sku  | individual_price | company_price | product_type | fulfillment_method |
      | Test Fetch   | TEST | 15               | 50            | video        | fetch              |
      | Test GitHub  | TEST | 15               | 199           | book         | github             |
      | Test Series  | TEST | 15               | 299           | video        | fetch              |
    And the a download exists with file name "test.txt" and description "test desc" for "Test Fetch"
    And the video with wistia id "1194803" exists for "Test Fetch"
    And the video with wistia id "1194804" exists for "Test Series"
    And the video with wistia id "1194805" exists for "Test Series"

  Scenario: A visitor signs up for an account through checkout
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    And I follow "Sign in."
    And I follow "Sign up"
    And I sign up with the following:
      | first_name      | John         |
      | last_name       | Doe          |
      | email           | john@doe.com |
      | password        | mypass       |
    Then I should see the checkout form
    And "Email" should be filled in with "john@doe.com"
    And "Name" should be filled in with "John Doe"
    And I should see "Sign out"

  @selenium @allow-rescue
  Scenario: A visitor purchases a product with paypal
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
    Then they should see "You can also create a user account" in the email body
    Then I should see a video
    And I should see the download links for video with id "1194803"
    And I should see a list of other products

  @selenium
  Scenario: A visitor purchases a product with stripe
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I pay using Stripe
    Then I should see that product "Test Fetch" is successfully purchased

  @selenium
  Scenario: A visitor purchases a product with stripe with a failure
    Given stripe is stubbed with a failure
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Your Company"
    Then I should see "$50"
    When I pay using Stripe
    Then I should see "There was a problem processing your credit card"

  @selenium
  Scenario: A visitor purchases a product with readers
    Given github is stubbed
    When I go to the products page
    And I follow "Test GitHub"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    And I should see "1st Reader"
    And I should not see "2nd Reader"
    When I go to the products page
    And I follow "Test GitHub"
    And I follow "Your Company"
    Then I should see "$199"
    And I should see "1st Reader"
    And I should see "2nd Reader"
    And I should see "3rd Reader"
    And I should see "4th Reader"
    And I should see "5th Reader"
    And I should see "6th Reader"
    And I should see "7th Reader"
    And I should see "8th Reader"
    And I should see "9th Reader"
    And I should see "10th Reader"
    When I add a reader
    When I pay using Paypal
    When emails are cleared
    And I submit the Paypal form
    Then I should see that product "Test GitHub" is successfully purchased
    And an email should be sent out with subject containing "receipt"

  @selenium
  Scenario: A visitor purchases with a valid coupon
    Given the following coupon exists:
      | code       | discount_type | amount |
      | VALENTINES | percentage    | 10     |
    When I go to the products page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    And I should see "$15"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$13.50 (10% off)"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    And I should see payment options

  @selenium @allow-rescue
  Scenario: A visitor purchase a product with 100%-off coupon
    Given the following coupon exists:
      | code | discount_type | amount |
      | 100  | percentage    | 100    |
    When I apply coupon code "100" to product named "Test Fetch"
    Then I should not see payment options
    When I completed the purchase
    Then I should see that product "Test Fetch" is successfully purchased
