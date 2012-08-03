Feature: Selecting a course and registering for it

  @selenium @allow-rescue
  Scenario: User registers for a section
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price    |
      | Test-Driven Haskell | name: Developers | 10000000 |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000,000"
    When I fill in all of the course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then carlos@santana.com is registered for the Test-Driven Haskell course

  @selenium @allow-rescue
  Scenario: User registers for a section with an invalid e-mail
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price    |
      | Test-Driven Haskell | name: Developers | 10000000 |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000,000"
    When I fill in all of the course registration fields for "carlos@blah"
    And I press "Proceed to checkout"
    Then I should see that the email is invalid

  @selenium
  Scenario: User registers with a valid coupon
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
    And I follow "Register"
    Then I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$9,000.00 (10% off)"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    When I fill in all of the course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then carlos@santana.com is registered for the Test-Driven Haskell course

  @selenium
  Scenario: User registers with a valid coupon which brings the price to 0
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
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    When I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$0"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then carlos@santana.com is registered for the Test-Driven Haskell course

  @selenium
  Scenario: User registers with an invalid coupon
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | discount_type | amount | active |
      | VALENTINES | percentage    | 10     | false  |
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 100   |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$100"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$100"
    And I should see "The coupon code you supplied is not valid"
    And the coupon form should be visible

  Scenario: User views a course with an external registration url
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | external_registration_url |
      | Test-Driven Haskell | name: Developers | http://engineyard.com     |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    Then the registration button should link to "http://engineyard.com"

  @selenium
  Scenario: User registers for a free section
    Given an audience exists with a name of "Developers"
    And the following course exists:
      | name                | audience         | price |
      | Test-Driven Haskell | name: Developers | 0     |
    And the following future section exists:
      | course                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "$0"
    When I fill in the required course registration fields for "carlos@santana.com"
    And I press "Proceed to checkout"
    Then carlos@santana.com is registered for the Test-Driven Haskell course
