Feature: Adding followups for a course

  Scenario: Adding a followup for a course
    Given today is June 13, 2010 12:00pm
    And I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I fill in the follow up 1 with "followup@example.com"
    And I press "Save Course"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 14, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then "followup@example.com" receives a follow up email for "Test-Driven Sleeping"
    When emails are cleared
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 15, 2010"
    And I select the end date of "June 15, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then "followup@example.com" does not receive a follow up email for "Test-Driven Sleeping"
    When I follow "Test-Driven Sleeping"
    Then I should see that "followup@example.com" has been notified on "June 13, 2010"

  @selenium
  Scenario: Adding more than one followup for a course
    Given I am signed in as an admin
    And a course exists with a name of "Test-Driven Sleeping"
    And a teacher exists with a name of "Albert Einstein"
    When I go to the admin page
    And I follow "Test-Driven Sleeping"
    And I follow "Add Follow up"
    And I fill in the following follow ups:
      | email                 |
      | followup1@example.com |
      | followup2@example.com |
    And I press "Save Course"
    When I go to the admin page
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 14, 2010"
    And I select the end date of "June 14, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then "followup1@example.com" receives a follow up email for "Test-Driven Sleeping"
    Then "followup2@example.com" receives a follow up email for "Test-Driven Sleeping"
    When emails are cleared
    And I follow "New Section" within the course "Test-Driven Sleeping"
    And I select the start date of "June 15, 2010"
    And I select the end date of "June 15, 2010"
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then "followup1@example.com" does not receive a follow up email for "Test-Driven Sleeping"
    Then "followup2@example.com" does not receive a follow up email for "Test-Driven Sleeping"

