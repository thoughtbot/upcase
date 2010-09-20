Feature: Scheduling a new course

  Scenario: Adding a new section for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    Then I should see the admin header
    When I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the section chargify id with "1234"
    And I press the button to re-run a course
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    Then I see that "Albert Einstein" is teaching

  Scenario: Adding a new section without filling in the teacher
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I press the button to re-run a course
    Then I should see the admin header
    And I see the "can't be blank" error for the following fields:
      | section start       |
      | section end         |
      | section chargify id |
    And I see that the section teacher can't be blank

  Scenario: Adding a new section and a new teacher
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I follow the link to create a new teacher
    And I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press the button to add a teacher
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 17, 2010"
    And I select the teacher "Samuel Beckett"
    And I fill in the section chargify id with "1234"
    And I press the button to re-run a course
    Then I see the successful section creation notice
    And I see the section from "June 14, 2010" to "June 17, 2010"
    When I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    Then I see that "Samuel Beckett" is teaching
    And "Samuel Beckett" has a Gravatar for "sbeckett@example.com"

  Scenario: Adding a new teacher with invalid data
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the home page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I follow the link to create a new teacher
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
    When I go to the home page
    And I follow the link to the section from "June 11, 2010" to "June 14, 2010"
    Then I should see the admin header
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
    When I go to the home page
    And I follow the link to the section from "June 14, 2010" to "June 17, 2010"
    And I blank the section start field
    And I press the button to update a section
    Then I see the "can't be blank" error for the section start field
    And I should see the admin header
