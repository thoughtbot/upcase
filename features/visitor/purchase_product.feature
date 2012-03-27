Feature: Purchase a Product
  As a visitor
  I want to purchase a product
  So that I can give you money

  Background:
    Given the following products exist:
      | name         | sku  | individual_price | company_price | product_type | fulfillment_method |
      | Test Fetch   | TEST | 15               | 50            | screencast   | fetch              |
      | Test GitHub  | TEST | 15               | 199           | book         | github             |

  Scenario: A visitor purchases a product
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    Then I should see "$15"
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Your Company"
    Then I should see "$50"

  Scenario: A visitor purchases a product with readers
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

  @selenium
  Scenario: A visitor purchases with a valid coupon
    Given the following coupon exists:
      | code       | percentage |
      | VALENTINES | 10         |
    When I go to the home page
    And I follow "Test Fetch"
    And I follow "Purchase for Yourself"
    And I should see "$15"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$13.50"
    And the coupon form should be hidden
    And the coupon form link should be hidden
