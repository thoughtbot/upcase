Feature: Adding a coupon

  Scenario: Add a coupin with blank required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow "Coupons"
    And I follow "New Coupon"
    And I press "Create Coupon"
    And I see the "can't be blank" error for the following fields:
      | code   |
      | amount |

  Scenario: Add a coupon with the required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow "Coupons"
    And I follow "New Coupon"
    When I fill in "Code" with "VALENTINES"
    And I fill in "Amount" with "20"
    And I check "Active"
    When I press "Create Coupon"
    Then I should see "Coupon successfully created"
    And I should see "VALENTINES (20%)"

  Scenario: Edit a coupon
    Given I am signed in as an admin
    And the following coupon exists:
      | code | amount |
      | CODE | 10     |
    When I go to the admin page
    And I follow "Coupons"
    And I follow "CODE"
    When I fill in "Code" with "VALENTINES"
    And I uncheck "Active"
    When I press "Update Coupon"
    Then I should see "Coupon successfully updated"
    And I should see "VALENTINES (10%)"
