Feature: Add a teacher
  In order to easily assign teacher to a section later on
  As an admin
  I want to be able to add a teacher

  Scenario: Add a teacher from the list of teachers page
    Given I am signed in as an admin
    And I am on the admin page
    When I follow "Teachers"
    And I follow "Add Teacher"
    Then I should be on the new teacher page
    When I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press "Save Teacher"
    Then I should be on the list of teachers page
    And I should see "Samuel Beckett" within the teachers list

  Scenario: Add a teacher from new section page
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I follow "Create New Teacher"
    When I fill in the teacher's name with ""
    And I fill in the teacher's email with ""
    And I press "Save Teacher"
    Then I should see "can't be blank"
    And I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press the button to add a teacher
    Then I should be on the new section page for "Test-Driven Sleeping"
    When I go to the admin page
    When I follow "Teachers"
    And I follow "Add Teacher"
    When I fill in the teacher's name with "Brian Griffin"
    And I fill in the teacher's email with "brian@example.com"
    And I press "Save Teacher"
    Then I should be on the list of teachers page

  Scenario: Add a teacher with invalid data
    Given I am signed in as an admin
    And I am on the admin page
    When I follow "Teachers"
    And I follow "Add Teacher"
    When I fill in the teacher's name with ""
    And I fill in the teacher's email with ""
    And I press "Save Teacher"
    Then I see the "can't be blank" error for the following fields:
      | teacher's name  |
      | teacher's email |
