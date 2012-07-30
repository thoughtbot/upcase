Feature: Admin views and edits models

  In order to manage content on the site
  As an admin,
  I want to view all the models and edit them in the admin interface.

  Background:
    Given the following users exist:
      | email                | admin |
      | admin@example.com    | true  |
      | stranger@example.com | false |

  Scenario: Admin can sign in
    When I sign in with "admin@example.com" and "password"
    And I am on the new admin page
    Then I should see the admin interface

  #  # rails_admin does not seem to work with `rake cucumber'
  #  Scenario: Non-admin cannot sign in
  #    When I am on the new admin page
  #    And I sign in with "stranger@example.com" and "password"
  #    And I am on the new admin page
  #    Then I should see the home page
