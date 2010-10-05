Feature: Editing a Section

  Scenario: Removing a teacher

  Scenario: Can not remove all teachers
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    And a teacher exists with a name of "Nikola Tesla"
    When I go to the admin page
    And I follow the link to re-run the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 14, 2010"
    And I select the teacher "Albert Einstein"
    And I select the teacher "Nikola Tesla"
    And I fill in the section chargify id with "1234"
    And I press the button to re-run a course
    And I follow the link to the section from "June 14, 2010" to "June 14, 2010"
    Then I see that "Albert Einstein" is teaching
    And I see that "Nikola Tesla" is teaching
    When I deselect the teacher "Albert Einstein"
    And I press the button to re-run a course
    And I follow the link to the section from "June 14, 2010" to "June 14, 2010"
    Then I do not see that "Albert Einstein" is teaching
    And I see that "Nikola Tesla" is teaching
