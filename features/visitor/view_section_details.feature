Feature: Viewing section details

  Scenario: Viewing details for a current section
    Given today is June 10, 2010
    And the following course exists on Chargify:
      | name                | location                        | start at | stop at  | price | chargify id |
      | Test-Driven Haskell | 41 Winter St., Boston, MA 02108 | 09:00:00 | 12:00:00 | 100   | 1234        |
    And the following section exists on Chargify:
      | course                    | starts on     | ends on       | chargify id |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 1234        |
    When I go to the home page
    Then I should see "Test-Driven Haskell"
    When I follow the link to the section from "June 13, 2010" to "June 16, 2010"
    Then I see the section location is "41 Winter St., Boston, MA 02108"
    And I see the section date is "June 13-16, 2010"
    And I see the section time is "09:00AM-12:00PM"
    And I see the section price is "$100"
