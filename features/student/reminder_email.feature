Feature: Reminder email

  Scenario: Recieve a reminder email a week before the section
    Given I am signed up as student of "Underwater Basket Weaving" on 2008-12-04
    Then I should have no emails
    When it is a week before 2008-12-04
    And the reminder email rake task runs
    Then I should have a reminder email for "Underwater Basket Weaving"
