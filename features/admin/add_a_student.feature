Feature: Adding a student to a course

  @wip
  Scenario: Add a student without full info
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts at    |
      | name: Test-Driven Sleeping | June 14,2010 |
    When I go to the home page
    And I follow the link to the sessions the course "Test-Driven Sleeping"
    And I follow the session that starts on June 14, 2010
    And I follow the link to add a new student
    And I press the button to enroll a new student
    Then I see the "can't be blank" error for the following fields:
      | name  |
      | email |

  @wip
  Scenario: Add an existing user to a section
    Given I am signed in as an admin
    And the following user exists:
      | name  | email             |
      | Jimbo | jones@example.com |
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts at    |
      | name: Test-Driven Sleeping | June 14,2010 |
    When I go to the home page
    And I follow the link to the sessions the course "Test-Driven Sleeping"
    And I follow the session that starts on June 14, 2010
    And I follow the link to add a new student
    And I fill in the student name with "Jimbo"
    And I fill in the student email with "jones@example.com"
    And I press the button to enroll a new student
    Then I see the successful section enrollment notice
    And I see the user "Jimbo <jones@example.com>" in the list of users

  @wip
  Scenario: Add a new user to a section
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts at    |
      | name: Test-Driven Sleeping | June 14,2010 |
    When I go to the home page
    And I follow the link to the sessions the course "Test-Driven Sleeping"
    And I follow the session that starts on June 14, 2010
    And I follow the link to add a new student
    And I fill in the student name with "Jimbo"
    And I fill in the student email with "jones@example.com"
    And I press the button to enroll a new student
    Then I see the successful section enrollment notice
    And I see the user "Jimbo <jones@example.com>" in the list of users
