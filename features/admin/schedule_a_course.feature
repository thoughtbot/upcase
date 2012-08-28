Feature: Scheduling a new course

  Scenario: Adding a new section for a course
    Given I am signed in as an admin
    And the following course exists:
      | name                 | maximum students | start_at | stop_at |
      | Test-Driven Sleeping | 10               | 09:00    | 17:00   |
    And a teacher exists with a name of "Albert Einstein"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    Then the seats available field should contain "10"
    And the section start time field should contain "2000-01-01 09:00:00 UTC"
    And the section stop time field should contain "2000-01-01 17:00:00 UTC"
    And I fill in the reminder email text with "This is really happening"
    When I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the seats available with "8"
    And I fill in the Boston address
    And I press "Save Section"
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    Then I see that "Albert Einstein" is teaching
    Then the seats available field should contain "8"

  Scenario: Scheduling a section emails teachers about the section
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following teacher exists:
      | name            | email                 |
      | Albert Einstein | aeinstein@example.com |
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then "aeinstein@example.com" is notified that they are scheduled to teach "Test-Driven Sleeping"

  Scenario: Adding a new section without filling in the teacher
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I press "Save Section"
    And I see the "can't be blank" error for the following fields:
      | section start       |
      | section end         |
    And I see that the section teacher can't be blank

  Scenario: Adding a new section and a new teacher
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I follow "Create New Teacher"
    And I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press the button to add a teacher
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Samuel Beckett"
    And I fill in the Boston address
    And I press "Save Section"
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    Then I see that "Samuel Beckett" is teaching
    And "Samuel Beckett" has a Gravatar for "sbeckett@example.com"

  Scenario: Adding a new section with multiple teachers
    Given today is "June 13, 2010"
    And I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I follow "Create New Teacher"
    And I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press the button to add a teacher
    And I follow "Create New Teacher"
    And I fill in the teacher's name with "Ralph Bot"
    And I fill in the teacher's bio with "Ralph knows his stuff."
    And I fill in the teacher's email with "rbot@example.com"
    And I press the button to add a teacher
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Samuel Beckett"
    And I select the teacher "Ralph Bot"
    And I fill in the Boston address
    And I press "Save Section"
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I sign out
    And I go to the home page
    And I follow "Test-Driven Sleeping"
    And I see that one of the teachers is "Samuel Beckett"
    And I see that one of the teachers is "Ralph Bot"

  Scenario: Adding a new teacher with invalid data
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I follow "Create New Teacher"
    And I press the button to add a teacher
    Then I see the "can't be blank" error for the following fields:
      | teacher's name  |
      | teacher's email |

  Scenario: Adding a new section as a student
    Given I am signed in as a student
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the new section page for "Test-Driven Sleeping"
    Then I see the permission denied error

  Scenario: Editing a section for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on     | ends on       |
      | name: Test-Driven Sleeping | June 11, 2010 | June 14, 2010 |
    When I go to the admin page
    And I follow the link to the section from "June 11, 2010" to "June 14, 2010"
    When I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I press the button to update a section
    Then I see the successful section update notice
    And I see the section from "June 14, 2010" to "June 17, 2010"

  Scenario: Try to update a section with invalid information
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on     | ends on       |
      | name: Test-Driven Sleeping | June 14, 2010 | June 17, 2010 |
    When I go to the admin page
    And I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    And I blank the section start field
    And I press the button to update a section
    Then I see the "can't be blank" error for the section start field
