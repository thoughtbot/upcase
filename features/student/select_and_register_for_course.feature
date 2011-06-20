Feature: Selecting a course and registering for it

  Scenario: No courses
    When I go to the home page
    Then I see the empty section description

  @javascript
  Scenario: User registers for a section then is signed in
    Given today is June 10, 2010
    And I am signed in as an admin
    And I create the following course:
      | Course Name        | Test-Driven Haskell |
      | Short description  | Short description   |
      | Course Description | It is great!        |
      | Price              | 10000000            |
      | Location Address   | 123 Main St.        |
      | Max Enrollment     | 5                   |
      | Start at           | 09:00               |
      | Stop at            | 13:00               |
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the link to register
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$10000000"
    And I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Password              | password           |
      | Organization          | Guitar Center      |
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
      | name     | unit_cost | quantity | description         |
      | Workshop | 10000000  | 1        | Test-Driven Haskell |
    Then I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"
    Then "workshops@thoughtbot.com" receives a registration notification email

  @javascript
  Scenario: Existing user registers for a section
    Given today is June 10, 2010
    And I am signed in as an admin
    And I create the following course:
      | Course Name        | Test-Driven Haskell |
      | Short description  | Short description   |
      | Course Description | It is great!        |
      | Price              | 10000000            |
      | Location Address   | 123 Main St.        |
      | Max Enrollment     | 5                   |
      | Start at           | 09:00               |
      | Stop at            | 13:00               |
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    And the following user exists:
      | email              | first name | last name | organization  | address1     | password |
      | carlos@santana.com | Carlos     | Santana   | Guitar Center | 123 Main St. | test     |
    And I sign in as "carlos@santana.com/test"
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the link to register
    Then I should not see "First name"
    And I should not see "Last name"
    And I should not see "Email"
    And I fill in the following:
      | Organization          | Guitar Center      |
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
      | name     | unit_cost | quantity | description         |
      | Workshop | 10000000  | 1        | Test-Driven Haskell |
    Then I am redirected to the freshbooks invoice page for "carlos@santana.com" on "Test-Driven Haskell"

  @javascript
  Scenario: User registers with a valid coupon
    Given today is June 10, 2010
    And the following coupon exists:
      | code       | percentage |
      | VALENTINES | 10         |
    And I am signed in as an admin
    And I create the following course:
      | Course Name        | Test-Driven Haskell |
      | Short description  | Short description   |
      | Course Description | It is great!        |
      | Price              | 100                 |
      | Location Address   | 123 Main St.        |
      | Max Enrollment     | 5                   |
      | Start at           | 09:00               |
      | Stop at            | 13:00               |
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the link to register
    Then I should see "Complete your registration for Test-Driven Haskell"
    And I should see "$100"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$90"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    And I fill in the following:
      | First name            | Carlos             |
      | Last name             | Santana            |
      | Email                 | carlos@santana.com |
      | Password              | password           |
      | Organization          | Guitar Center      |
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
    And the invoice for "carlos@santana.com" has a discount of "10"
    And the invoice for "carlos@santana.com" has the following line item:
      | name     | unit_cost  | quantity | description         |
      | Workshop | 100        | 1        | Test-Driven Haskell |
  
  @javascript
  Scenario: User registers with an invalid coupon
    Given today is June 10, 2010
    And the following coupon exists:
      | code       | percentage | active |
      | VALENTINES | 10         | false  |
    And I am signed in as an admin
    And I create the following course:
      | Course Name        | Test-Driven Haskell |
      | Short description  | Short description   |
      | Course Description | It is great!        |
      | Price              | 100                 |
      | Location Address   | 123 Main St.        |
      | Max Enrollment     | 5                   |
      | Start at           | 09:00               |
      | Stop at            | 13:00               |
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the link to register
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
    And I am signed in as an admin
    And I create the following course:
      | Course Name               | Test-Driven Haskell   |
      | Short description         | Short description     |
      | Course Description        | It is great!          |
      | Price                     | 10000000              |
      | Location Address          | 123 Main St.          |
      | Max Enrollment            | 5                     |
      | Start at                  | 09:00                 |
      | Stop at                   | 13:00                 |
      | External registration url | http://engineyard.com |
    And I create the following section for "Test-Driven Haskell":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    And I sign out
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    Then the registration button should link to "http://engineyard.com"
