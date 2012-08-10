Feature: Purchase a Product
  As a visitor
  I want to purchase a product
  So that I can give you money

  Background:
    Given the following products exist:
      | name         | id | sku  | individual_price | company_price | product_type | fulfillment_method |
      | Test Fetch   | 1  | TEST | 15               | 50            | screencast   | fetch              |
      | Test GitHub  | 2  | TEST | 15               | 199           | book         | github             |
    Given the following downloads exist:
      | download_file_name  | product_id    | description |
      | test.txt            | 1             | test desc   |
    And the following videos exist:
      | product_id | wistia_id |
      | 1          | 1194803   |

  Scenario: A visitor signs up for an account through checkout
    When I go to the home page
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
  Scenario: A visitor purchases a product with paypal
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
    Then they should see "You can also create a user account" in the email body
    When I follow "Watch or download video"
    Then I should see a video
    And I should see the download links for video with id "1194803"
    And I should see a list of other products

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
  Scenario: A visitor purchases a product with stripe
    Given stripe is stubbed with a failure
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Your Company"
    Then I should see "$50"
    When I pay using Stripe
    Then I should see "There was a problem processing your credit card"

  @selenium
  Scenario: A visitor purchases a product with readers
    Given github is stubbed
    When I go to the home page
    And I follow "Test GitHub"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    And I should see "1st Reader"
    And I should not see "2nd Reader"
    When I go to the home page
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

  @selenium @allow-rescue
  Scenario: A user purchases a product with a reader
    Given github is stubbed
    And I have signed up with "user@example.com"
    And I sign in with "user@example.com"
    When I go to the home page
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
  Scenario: A visitor purchases with a valid coupon
    Given the following coupon exists:
      | code       | discount_type | amount |
      | VALENTINES | percentage    | 10     |
    When I go to the home page
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

  @selenium
  Scenario: A visitor purchase a product with 100%-off coupon
    Given the following coupon exists:
      | code | discount_type | amount |
      | 100  | percentage    | 100    |
    When I apply coupon code "100" to product named "Test Fetch"
    Then I should not see payment options
    When I completed the purchase
    Then I should see that product "Test Fetch" is successfully purchased
