Feature: View an external product listing
  As a user
  I want to view an external product listing
  So that I can be linked to purchase it

  Scenario: View an external prodict
    Given there is an external product named "Test External"
    When I go to the home page
    And I follow "Test External"
    Then the purchase link should link to the external product
