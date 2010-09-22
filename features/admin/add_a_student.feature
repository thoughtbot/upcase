Feature: Adding a student to a course

  Scenario: Add a student without full info
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on    | ends on       |
      | name: Test-Driven Sleeping | June 14,2010 | June 18, 2010 |
    When I go to the admin page
    And I follow the link to the section from "June 14, 2010" to "June 18, 2010"
    And I follow the link to add a new student
    And I press the button to enroll a new student
    Then I see the "can't be blank" error for the following fields:
      | student's first name  |
      | student's last name   |
      | student's email       |

  Scenario: Add an existing user to a section
    Given I am signed in as an admin
    And the following user exists:
      | first name | last name | email             |
      | Jimbo      | Ones      | jones@example.com |
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on     | ends on       |
      | name: Test-Driven Sleeping | June 14, 2010 | June 18, 2010 |
    When I go to the admin page
    And I follow the link to the section from "June 14, 2010" to "June 18, 2010"
    And I follow the link to add a new student
    And I fill in the student's first name with "Jimbo"
    And I fill in the student's last name with "Ones"
    And I fill in the student's email with "jones@example.com"
    And I press the button to enroll a new student
    Then I see the successful section enrollment notice
    And I see the user "Jimbo Ones" in the list of users

  Scenario: Add a new user to a section
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on    | ends on       |
      | name: Test-Driven Sleeping | June 14,2010 | June 18, 2010 |
    When I go to the admin page
    And I follow the link to the section from "June 14, 2010" to "June 18, 2010"
    And I follow the link to add a new student
    And I fill in the student's first name with "Jimbo"
    And I fill in the student's last name with "Jones"
    And I fill in the student's email with "jones@example.com"
    And I press the button to enroll a new student
    Then I see the successful section enrollment notice
    And I see the user "Jimbo Jones" in the list of users
    And "jones@example.com" receives a set your password link

  Scenario: Adding a user as a student
    Given I am signed in as a student
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on    | ends on       |
      | name: Test-Driven Sleeping | June 14,2010 | June 18, 2010 |
    When I go to the page to add a new student to the section from "June 14, 2010" to "June 18, 2010"
    Then I see the permission denied error
