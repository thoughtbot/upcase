Feature: Viewing the admin interface

  Scenario: Admin link
    Given I am signed in as an admin
    And I am on the home page
    Then I see the link to the admin interface
    When I follow the link to the admin interface
    Then I should be on the admin page
    When I am signed in as a student
    Then I do not see the link to the admin interface
