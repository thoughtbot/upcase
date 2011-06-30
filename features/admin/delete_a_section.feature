Feature: Delete a section

  Scenario: Deleting a section for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | course                     | starts on     | ends on       |
      | name: Test-Driven Sleeping | June 11, 2010 | June 14, 2010 |
    When I go to the admin page
    And I follow the delete link to the section from "June 11, 2010" to "June 14, 2010"
    Then I should see "Section deleted"
    And I should not see the section from "June 11, 2010" to "June 14, 2010"
