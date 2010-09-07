Feature: Selecting a course and registering for it

  Scenario: No courses
    When I go to the home page
    Then I see the empty section description

  Scenario: User registers for a section then is signed in
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on      | ends on        | chargify id | registration link                                                 |
      | 1234 | name: Test-Driven Haskell | June 13, 2010  | June 16, 2010  | 1234        | http://thoughtbot-workshops.chargify.com/h/1234/subscriptions/new |
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the external registration link
    And I fill in the following Chargify customer:
      | first name | last name | email              |
      | Mike       | Jones     | mjones@example.com |
    And I press the button to submit the Chargify form
    Then I am signed in as:
      | first name | last name | email              |
      | Mike       | Jones     | mjones@example.com |
    And mjones@example.com is registered for the Test-Driven Haskell course

  Scenario: Existing user registers for a section
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id |
      | Test-Driven Haskell | 1234        |
    And the following section exists on Chargify:
      | id   | course                    | starts on      | ends on        | chargify id | registration link                                                 |
      | 1234 | name: Test-Driven Haskell | June 13, 2010  | June 16, 2010  | 1234        | http://thoughtbot-workshops.chargify.com/h/1234/subscriptions/new |
    And I am signed in as "mjones@example.com"
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the external registration link
    And I fill in the following Chargify customer:
      | first name | last name | email              |
      | Mike       | Jones     | mjones@example.com |
    And I press the button to submit the Chargify form
    Then I am signed in as:
      | first name | last name | email              |
      | Mike       | Jones     | mjones@example.com |
    And mjones@example.com is registered for the Test-Driven Haskell course

  Scenario: Registered user views course
    Given today is June 10, 2010
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
      | Test-Driven COBOL   |
      | Test-Driven JS      |
    And the following section exists:
      | course                    | starts on      | ends on        |
      | name: Test-Driven Haskell | June 13, 2010  | June 16, 2010  |
      | name: Test-Driven COBOL   | June 12, 2010  | June 30, 2010  |
      | name: Test-Driven JS      | June 18, 2009  | June 19, 2009  |
    And I am signed in as "spj@example.com"
    And the following registration exists:
      | section               | user                   |
      | starts_on: 2010-06-13 | email: spj@example.com |
      | starts_on: 2009-06-18 | email: spj@example.com |
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    Then I see the course resource page for "Test-Driven Haskell"
    When I go to the home page
    And I follow the link to the Test-Driven COBOL course
    Then I see the course registration page for "Test-Driven COBOL"
    When I go to the home page
    And I follow the link to the Test-Driven JS course
    Then I see the course resource page for "Test-Driven JS"
