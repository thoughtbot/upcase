Feature: View an external product listing
  As a user
  I want to view an external product listing
  So that I can be linked to purchase it

  Scenario: View an external product
    Given there is an external product named "Test External"
    When I visit the product page for "Test External"
    Then the purchase link should link to the external product
