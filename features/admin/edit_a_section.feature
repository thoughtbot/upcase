Feature: Editing a Section

  Scenario: Can not remove all teachers
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    And a teacher exists with a name of "Nikola Tesla"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 14, 2010"
    And I select the teacher "Albert Einstein"
    And I select the teacher "Nikola Tesla"
    And I press "Save Section"
    And I follow the link to the section from "June 14, 2010" to "June 14, 2010"
    Then I see that "Albert Einstein" is teaching
    And I see that "Nikola Tesla" is teaching
    When I deselect the teacher "Albert Einstein"
    And I press "Save Section"
    And I follow the link to the section from "June 14, 2010" to "June 14, 2010"
    Then I do not see that "Albert Einstein" is teaching
    And I see that "Nikola Tesla" is teaching

  Scenario: Edit number of seats available
    Given I am signed in as an admin
    And the following course exists:
      | name                 | maximum students |
      | Test-Driven Sleeping | 20               |
    And I create the following section for "Test-Driven Sleeping":
      | Starts on | January 13, 2011 |
      | Ends on   | January 15, 2011 |
    When I go to the admin page
    And I follow the link to the section from "January 13, 2011" to "January 15, 2011"
    Then the seats available field should contain "20"
    When I fill in the seats available with "8"
    And I press "Save Section"
    And I follow the link to the section from "January 13, 2011" to "January 15, 2011"
    Then the seats available field should contain "8"

  Scenario: See paid and unpaid registrations
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Nikola Tesla"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 14, 2010"
    And I select the teacher "Nikola Tesla"
    And I press "Save Section"
    And the following registrations exist:
      | paid  | first_name | last_name | section                  |
      | true  | Paid       | Person    | starts_on: June 14, 2010 |
      | false | Deliquent  | Person    | starts_on: June 14, 2010 |
    And I follow the link to the section from "June 14, 2010" to "June 14, 2010"
    Then I see that "Paid Person" has paid
    And I see that "Deliquent Person" has not paid
    And I should see "1 Student"
