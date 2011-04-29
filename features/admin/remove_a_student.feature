Feature: Removing a student from a course

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
    Then I should see "1 Student"
    And I follow "Delete" for the registration for "jones@example.com"
    Then I should see "Student registration has been deleted"
    And should see "0 Students"
