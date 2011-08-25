Feature: Audiences

  Scenario: Add an audience with invalid fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow "Audiences"
    And I follow "New Audience"
    And I press "Create Audience"
    And I see the "can't be blank" error for the following fields:
      | audience name |

  Scenario: Add an audience with the required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow "Audiences"
    And I follow "New Audience"
    When I fill in "Name" with "Developers"
    When I press "Create Audience"
    Then I should see "Audience successfully created"
    And I should see "Developers"

  Scenario: Edit an audience
    Given I am signed in as an admin
    And the following audience exists:
      | name      |
      | Developers |
    When I go to the admin page
    And I follow "Audiences"
    And I follow "Developers"
    When I fill in "Name" with "Designers"
    When I press "Update Audience"
    Then I should see "Audience successfully updated"
    And I should see "Designers"
