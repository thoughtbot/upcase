Feature: Manage workshop sections

  Background:
    Given the following user exists:
      | email                | admin |
      | admin@example.com    | true  |
    And the following workshop exists:
      | name                   |
      | Rails for Django users |
    And the following sections exist for the workshop "Rails for Django users":
      | starts_on  | ends_on    |
      | 2013-01-21 | 2013-01-25 |
      | 2013-01-31 | 2013-02-04 |

  Scenario: Getting an overview of sections
    When I sign in with "admin@example.com" and "password"
    And I am on the new admin page
    And I follow "Workshops"
    Then I should see "Rails for Django users"
    And I should see "January 21-25, 2013"
    And I should see "January 31-February 04, 2013"
    When I follow "January 21-25, 2013"
    Then I should see "Edit Section"
    And I should see "January 21-25, 2013"

  Scenario: See paid registrations
    Given "Paid Person" has registered and paid for the section on "January 21, 2013"
    And I sign in with "admin@example.com" and "password"
    When I am on the new admin page
    And I follow "Workshops"
    And I follow "January 21-25, 2013"
    And I follow "Students"
    Then I see that "Paid Person" has paid
    And I should see "1 Student"
