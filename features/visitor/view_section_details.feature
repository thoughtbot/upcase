Feature: Viewing section details

  Scenario: Viewing details for a current section
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following course exists on Chargify:
      | name                | location name     | location                        | start at | stop at  | price | chargify id | terms of service |
      | Test-Driven Haskell | Thoughtbot Office | 41 Winter St., Boston, MA 02108 | 09:00:00 | 12:00:00 | 100   | 1234        | No pets allowed  |
    And the following section exists on Chargify:
      | course                    | starts on     | ends on       | chargify id |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And the following questions exist:
      | course                    | question      | answer |
      | name: Test-Driven Haskell | What color?   | Blue   |
      | name: Test-Driven Haskell | Pets allowed? | No     |
    And "Ralph Bot" is teaching the section from "June 13, 2010" to "June 16, 2010"
    When I go to the home page
    Then I should see "Test-Driven Haskell"
    When I follow the link to the section from "June 13, 2010" to "June 16, 2010"
    Then I see the section location is "41 Winter St., Boston, MA 02108"
    And I see the section location's name is "Thoughtbot Office"
    And I see the section date is "June 13-16, 2010"
    And I see the section time is "9:00AM-12:00PM"
    And I see the section price is "$100"
    And I see the section terms of service is "No pets allowed"
    And I see that one of the teachers is "Ralph Bot"
    And I see "Ralph Bot"'s avatar
    And I see the question "What color?"
    And I see the answer "Blue"
    And I see the question "Pets allowed?"
    And I see the answer "No"

  Scenario: Viewing a section that is full
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | chargify id | maximum students |
      | Test-Driven Haskell | 1234        | 5                |
    And the following section exists on Chargify:
      | id   | course                    | starts on     | ends on       | chargify id |
      | 1234 | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    And "Test-Driven Haskell" has 5 registrations
    When I go to the home page
    And I follow the link to the Test-Driven Haskell course
    Then I should not see the external registration link
    And I should see "Workshop is full"
    And I should see "Want to be notified when this course is rescheduled?"
