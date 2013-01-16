@selenium
Feature: Sorting workshops
  In order to display workshops in a custom order
  As an admin
  I want to be able to sort the workshops

  Scenario: Sorting
    Given I am signed in as an admin
    And the following workshops exist:
      | name                       | position |
      | Test-Driven Machine Code   | 1        |
      | Test-Driven Coloring Books | 2        |
      | Test-Driven Testing        | 3        |
    When I go to the admin page
    And I drag the workshop "Test-Driven Testing" before "Test-Driven Coloring Books"
    And I go to the admin page
    Then I should see the following workshops in order:
      | Test-Driven Machine Code   |
      | Test-Driven Testing        |
      | Test-Driven Coloring Books |
    When I go to the home page
    Then I should see the following workshops in order:
      | Test-Driven Machine Code   |
      | Test-Driven Testing        |
      | Test-Driven Coloring Books |
