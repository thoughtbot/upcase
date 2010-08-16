Feature: Selecting a course and registering for it

  Scenario: No courses
    When I go to the home page
    Then I see the empty section description

  @wip
  Scenario: User registers for a section
    Given today is June 10, 2010
    And the following course exists:
      | name                |
      | Test-Driven Haskell |
    And the following section exists:
      | course                    | starts on      | ends on        |
      | name: Test-Driven Haskell | June 13, 2010  | June 16, 2010  |
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    And I follow the link to register for a section
    Then I see the external registration page

  @wip
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
    And a user exists with an email of "spj@example.com"
    And the following registration exists:
      | section                  | user                   |
      | starts_on: June 13, 2010 | email: spj@example.com |
      | starts_on: June 18, 2009 | email: spj@example.com |
    And I am signed in as "spj@example.com"
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    Then I see the course resource page for "Test-Driven Haskell"
    When I go to the home page
    And I follow the link to the Test-Driven COBOL course
    Then I see the course registration page for "Test-Driven COBOL"
    When I go to the home page
    And I follow the link to the Test-Driven JS course
    Then I see the course resource page for "Test-Driven JS"
