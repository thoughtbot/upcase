@wip
Feature: Admin views and edits models

  In order to manage content on the site
  As an admin,
  I want to view all the models and edit them in the admin interface.

  Background:
    Given the following users exist:
      | email                | role  |
      | admin@example.com    | admin |
      | stranger@example.com |       |

  Scenario: Admin can sign in and sign out
    When I am on admin home page
    Then I should see login form
    When I sign in with "admin@example.com" and "password"
    Then I should see the admin interface
    When I sign out
    Then I should see the home page

  Scenario: Non-admin cannot sign in
    When I am on admin home page
    And I sign in with "stranger@example.com" and "password"
    Then I should see the home page
