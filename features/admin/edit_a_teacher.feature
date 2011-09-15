Feature: Edit a teacher
  In order to correct teacher's data
  As an admin
  I want to be able to edit a teacher

  Scenario: Edit a teacher with valid data
    Given a teacher exists with a name of "Albert Einstein"
    And I am signed in as an admin
    When I am on the admin page
    And I follow "Teachers"
    And I follow "Albert Einstein"
    When I fill in the teacher's name with "Samuel Beckett"
    And I fill in the teacher's bio with "He's, like, famous or something."
    And I fill in the teacher's email with "sbeckett@example.com"
    And I press "Save Teacher"
    Then I should be on the list of teachers page
    And I should see "Samuel Beckett" within the teachers list
    And I should not see "Albert Einstein" within the teachers list
    When I follow "Samuel Beckett"
    Then the teacher's bio field should contain "He's, like, famous or something."
    And the teacher's email field should contain "sbeckett@example.com"

  Scenario: Edit a teacher with invalid data
    Given a teacher exists with a name of "Albert Einstein"
    And I am signed in as an admin
    When I am on the admin page
    And I follow "Teachers"
    And I follow "Albert Einstein"
    When I fill in the teacher's name with ""
    And I fill in the teacher's bio with ""
    And I fill in the teacher's email with ""
    And I press "Save Teacher"
    Then I see the "can't be blank" error for the following fields:
      | teacher's name  |
      | teacher's email |
