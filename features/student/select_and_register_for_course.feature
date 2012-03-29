Feature: Selecting a course and registering for it

  Scenario: No courses
    When I go to the home page
    Then I see the empty section description


  @selenium
  Scenario: User registers for a section
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And time is unfrozen
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "10000000"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    And KISSmetrics receives the "Started Registration" event with:
      | Course Name | Test-Driven Haskell |
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000,000"
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
    And carlos@santana.com is registered for the Test-Driven Haskell course
    And KISSmetrics receives the "Submitted Registration" event for "carlos@santana.com" over HTTP with:
      | Course Name | Test-Driven Haskell |
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
      | name     | unit_cost | quantity | description         |
      | Workshop | 10000000  | 1        | Test-Driven Haskell |
    Then I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"
    And "billing@santana.com" receives an invoice email
    And "workshops@thoughtbot.com" should receive no emails
    And "carlos@santana.com" should receive no emails
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should not be paid
    When I pay for "carlos@santana.com" taking "Test-Driven Haskell"
    Then "workshops@thoughtbot.com" receives a registration notification email
    Then "carlos@santana.com" receives a registration confirmation email
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should be paid

  @selenium
  Scenario: User registers with a valid coupon
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And time is unfrozen
    And the following coupon exists:
      | code       | discount_type | amount |
      | VALENTINES | percentage    | 10     |
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "10000"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$9,000.00 (10% off)"
    And the coupon form should be hidden
    And the coupon form link should be hidden
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
    And carlos@santana.com is registered for the Test-Driven Haskell course
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
  Scenario: User registers with a valid coupon which brings the price to 0 
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And time is unfrozen
    And the following coupon exists:
      | code       | amount | discount_type |
      | VALENTINES | 100    | percentage    |
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "10000"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$0"
    And the coupon form should be hidden
    And the coupon form link should be hidden
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
    And carlos@santana.com is registered for the Test-Driven Haskell course
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

  @selenium
  Scenario: User registers with an invalid coupon
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And the following coupon exists:
      | code       | discount_type | amount | active |
      | VALENTINES | percentage    | 10     | false  |
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "100"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
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
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And time is unfrozen
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "10000000"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I fill in "External registration url" with "http://engineyard.com"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow "Test-Driven Haskell"
    Then the registration button should link to "http://engineyard.com"

  @selenium
  Scenario: User registers for a free section
    Given today is June 10, 2010
    And the following audience exists:
      | name       |
      | Developers |
    And time is unfrozen
    And I am signed in as an admin
    When I go to the admin page
    And I follow "New Course"
    And I fill in "Course Name" with "Test-Driven Haskell"
    And I fill in "Short description" with "Short description"
    And I fill in "Course Description" with "It is great!"
    And I select "Developers" from "Audience"
    And I fill in "Price" with "0"
    And I fill in "Location Address" with "123 Main St."
    And I fill in "Max Enrollment" with "5"
    And I fill in "Start at" with "09:00"
    And I fill in "Stop at" with "13:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register"
    And KISSmetrics receives the "Started Registration" event with:
      | Course Name | Test-Driven Haskell |
    And I should see "$0"
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
    And carlos@santana.com is registered for the Test-Driven Haskell course
    And KISSmetrics receives the "Submitted Registration" event for "carlos@santana.com" over HTTP with:
      | Course Name | Test-Driven Haskell |
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
      | name     | unit_cost | quantity | description         |
      | Workshop | 0         | 1        | Test-Driven Haskell |
    Then I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"
    And "billing@santana.com" receives an invoice email
    And the registration for "carlos@santana.com" taking "Test-Driven Haskell" should be paid
    Then "workshops@thoughtbot.com" receives a registration notification email
    Then "carlos@santana.com" receives a registration confirmation email
