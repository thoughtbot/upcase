Feature: Freshbooks stores information about registrations

  @selenium @allow-rescue
  Scenario: Freshbooks stores information on paid section registration
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price    |
      | Test-Driven Haskell | name: Developers | 10000000 |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "REGISTER FOR THIS WORKSHOP"
    When I fill in the required course registration fields for "carlos@santana.com"
    When I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Billing email         | billing@santana.com|
      | Organization          | Guitar Center      |
      | Phone                 | 617 123 1234       |
      | Address 1             | 123 Main St.       |
      | City                  | Boston             |
      | State                 | MA                 |
      | Zip code              | 02114              |
    And I press "Proceed to checkout"
    Then the freshbooks client id for "carlos@santana.com" is set correctly
    And a freshbooks invoice for "carlos@santana.com" is created with:
      | first_name   | Carlos        |
      | last_name    | Santana       |
      | organization | Guitar Center |
      | p_street1    | 123 Main St.  |
      | p_city       | Boston        |
      | p_code       | 02114         |
      | status       | sent          |
    And the invoice for "carlos@santana.com" has the following line item:
      | name     | unit_cost | quantity | description         |
      | Workshop | 10000000  | 1        | Test-Driven Haskell |
    Then I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"
    And "billing@santana.com" receives an invoice email
    And "learn@thoughtbot.com" should receive no emails
    And "carlos@santana.com" should receive no emails
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should not be paid
    When I pay for "carlos@santana.com" taking "Test-Driven Haskell"
    Then "learn@thoughtbot.com" receives a registration notification email
    Then "carlos@santana.com" receives a registration confirmation email
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should be paid

  @selenium
  Scenario: Freshbooks stores info about paid registration with valid coupon
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | discount_type | amount |
      | VALENTINES | percentage    | 10     |
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 10000 |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "REGISTER FOR THIS WORKSHOP"
    And I follow "Have a coupon code?"
    Then the coupon form should be visible
    When I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    And I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Organization          | Guitar Center      |
      | Billing email         | carlos@santana.com |
      | Phone                 | 617 123 1234       |
      | Address 1             | 123 Main St.       |
      | City                  | Boston             |
      | State                 | MA                 |
      | Zip code              | 02114              |
    And I press "Proceed to checkout"
    Then carlos@santana.com is registered for the Test-Driven Haskell course
    And the freshbooks client id for "carlos@santana.com" is set correctly
    And a freshbooks invoice for "carlos@santana.com" is created with:
      | first_name   | Carlos        |
      | last_name    | Santana       |
      | organization | Guitar Center |
      | p_street1    | 123 Main St.  |
      | p_city       | Boston        |
      | p_code       | 02114         |
      | status       | sent          |
    And the invoice for "carlos@santana.com" has the following line item:
      | name     | unit_cost   | quantity | description         |
      | Workshop | 9000.0      | 1        | Test-Driven Haskell |

  @selenium
  Scenario: Freshbooks stores info about free section
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 0     |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "REGISTER FOR THIS WORKSHOP"
    And I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Billing email         | billing@santana.com|
      | Organization          | Guitar Center      |
      | Phone                 | 617 123 1234       |
      | Address 1             | 123 Main St.       |
      | City                  | Boston             |
      | State                 | MA                 |
      | Zip code              | 02114              |
    And I press "Proceed to checkout"
    Then the freshbooks client id for "carlos@santana.com" is set correctly
    And a freshbooks invoice for "carlos@santana.com" is created with:
      | first_name   | Carlos        |
      | last_name    | Santana       |
      | organization | Guitar Center |
      | p_street1    | 123 Main St.  |
      | p_city       | Boston        |
      | p_code       | 02114         |
      | status       | sent          |
    And the invoice for "carlos@santana.com" has the following line item:
      | name     | unit_cost | quantity | description         |
      | Workshop | 0         | 1        | Test-Driven Haskell |
    And I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"
    And "billing@santana.com" receives an invoice email
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should be paid
    And "learn@thoughtbot.com" receives a registration notification email
    And "carlos@santana.com" receives a registration confirmation email

  @selenium
  Scenario: Freshbooks stores info when registering with a valid coupon which brings the price to 0
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | amount | discount_type |
      | VALENTINES | 100    | percentage    |
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 10000 |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "REGISTER FOR THIS WORKSHOP"
    And I follow "Have a coupon code?"
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    And I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Organization          | Guitar Center      |
      | Billing email         | carlos@santana.com |
      | Phone                 | 617 123 1234       |
      | Address 1             | 123 Main St.       |
      | City                  | Boston             |
      | State                 | MA                 |
      | Zip code              | 02114              |
    And I press "Proceed to checkout"
    And the freshbooks client id for "carlos@santana.com" is set correctly
    And a freshbooks invoice for "carlos@santana.com" is created with:
      | first_name   | Carlos        |
      | last_name    | Santana       |
      | organization | Guitar Center |
      | p_street1    | 123 Main St.  |
      | p_city       | Boston        |
      | p_code       | 02114         |
      | status       | sent          |
    And the invoice for "carlos@santana.com" has the following line item:
      | name     | unit_cost  | quantity | description         |
      | Workshop | 0.0        | 1        | Test-Driven Haskell |
