Feature: Viewing upcoming workshop details

  Scenario: Upcoming workshop price format
    Given the following workshop exists:
      | name                | start at | stop at  | individual_price |
      | Test-Driven Haskell | 09:00:00 | 12:00:00 | 1000             |
    And the following section exists:
      | workshop                    |
      | name: Test-Driven Haskell |
    When I view all products
    Then I should see "Test-Driven Haskell"
    When I follow "Test-Driven Haskell"
    Then I should see "$1,000"

  Scenario: workshop has FAQ
    Given a workshop exists with a name of "Test-Driven Erlang"
    And the following questions exist:
      | workshop                 | question      | answer |
      | name: Test-Driven Erlang | What color?   | Blue   |
      | name: Test-Driven Erlang | Pets allowed? | No     |
    When I view all products
    And I follow "Test-Driven Erlang"
    Then I see the question "What color?"
    And I see the answer "Blue"
    And I see the question "Pets allowed?"
    And I see the answer "No"

  Scenario: workshop does not have FAQ
    Given a workshop exists with a name of "Test-Driven Erlang"
    When I view all products
    And I follow "Test-Driven Erlang"
    Then I should not see "Frequently asked questions"

  Scenario: Viewing details for a workshop with one upcoming section
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And the following workshop exists:
      | name                | individual_price |
      | Test-Driven Haskell | 1000             |
    And the following section exists:
      | workshop                  | starts on     | ends on       | start at | stop at  | address       | city   | state | zip   |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 09:00:00 | 12:00:00 | 41 Winter St. | Boston | MA    | 02108 |
    And the following questions exist:
      | workshop                  | question      | answer |
      | name: Test-Driven Haskell | What color?   | Blue   |
      | name: Test-Driven Haskell | Pets allowed? | No     |
    And "Ralph Bot" is teaching the section from "June 13, 2010" to "June 16, 2010"
    When I view all products
    Then I should see "Test-Driven Haskell"
    When I follow "Test-Driven Haskell"
    Then I see the section location is "41 Winter St."
    And I should see "June 13-16, 2010"
    And I should see "9:00AM-12:00PM"
    And I should see "$1,000"
    And I see that one of the teachers is "Ralph Bot"
    And I see "Ralph Bot"'s avatar
    And I see the question "What color?"
    And I see the answer "Blue"
    And I see the question "Pets allowed?"
    And I see the answer "No"

  @selenium
  Scenario: Viewing details for a workshop with multiple upcoming sections
    Given today is June 10, 2010
    And a teacher exists with a name of "Ralph Bot"
    And a teacher exists with a name of "Joe Teacher"
    And the following workshop exists:
      | name                | individual_price |
      | Test-Driven Haskell | 1000             |
    And the following section exists:
      | workshop                  | starts on     | ends on       | start at | stop at  | address       | city          | state | zip   |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 09:00:00 | 12:00:00 | 41 Winter St. | Boston        | MA    | 02108 |
      | name: Test-Driven Haskell | June 20, 2010 | June 22, 2010 | 09:00:00 | 12:00:00 | 156 2nd St.   | San Francisco | CA    | 94105 |
    And "Ralph Bot" is teaching the section from "June 13, 2010" to "June 16, 2010"
    And "Joe Teacher" is teaching the section from "June 20, 2010" to "June 22, 2010"
    When I view all products
    Then I should see "Test-Driven Haskell"
    When I follow "Test-Driven Haskell"
    Then I see the section location is "41 Winter St."
    And I see the section location is "156 2nd St."
    And I should see "June 13-16, 2010"
    And I should see "9:00AM-12:00PM"
    And I should see "$1,000"
    And I see that one of the teachers is "Ralph Bot"
    And I see "Ralph Bot"'s avatar
    And I should see "June 20-22, 2010"
    And I see that one of the teachers is "Joe Teacher"

  Scenario: Viewing details for a workshop with one multiple upcoming sections taught by the same person
    Given today is June 10, 2010
    And a teacher exists with a name of "Joe Teacher"
    And the following workshop exists:
      | name                | individual_price |
      | Test-Driven Haskell | 1000             |
    And the following section exists:
      | workshop                  | starts on     | ends on       | start at | stop at  | address       | city          | state | zip   |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 09:00:00 | 12:00:00 | 41 Winter St. | Boston        | MA    | 02108 |
      | name: Test-Driven Haskell | June 20, 2010 | June 22, 2010 | 09:00:00 | 12:00:00 | 156 2nd St.   | San Francisco | CA    | 94105 |
    And "Joe Teacher" is teaching the section from "June 13, 2010" to "June 16, 2010"
    And "Joe Teacher" is teaching the section from "June 20, 2010" to "June 22, 2010"
    When I view all products
    And I follow "Test-Driven Haskell"
    Then I should see that "Joe Teacher" is teaching both sections

  Scenario: Viewing a workshop that is full
    Given today is June 10, 2010
    And the following workshop exists:
      | name                | maximum students |
      | Test-Driven Haskell | 5                |
    And the following section exists:
      | workshop                  | starts on     | ends on       |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    And "Test-Driven Haskell" has 5 registrations
    When I view all products
    And I follow "Test-Driven Haskell"
    Then I should a registration link to be notified
    And I should see "Sold Out"
    And I should see "Want to be notified the next time we run this workshop?"

  Scenario: Viewing a smaller section that is full
    Given today is June 10, 2010
    And the following workshop exists:
      | name                | maximum students |
      | Test-Driven Haskell | 20               |
    And the following section exists:
      | workshop                  | starts on     | ends on       | seats available |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 | 5               |
    And "Test-Driven Haskell" has 5 registrations
    When I view all products
    And I follow "Test-Driven Haskell"
    Then I should a registration link to be notified
    And I should see "Sold Out"
    And I should see "Want to be notified the next time we run this workshop?"

  Scenario: Viewing an online workshop
    Given today is June 10, 2010
    And the following workshop exists:
      | name                | online |
      | Test-Driven Haskell | true   |
    And the following section exists:
      | workshop                  | starts on     | ends on       |
      | name: Test-Driven Haskell | June 13, 2010 | June 16, 2010 |
    When I view all products
    And I follow "Test-Driven Haskell"
    Then I should see the date range

  Scenario: Viewing an online workshop with no sections
    Given today is June 10, 2010
    And the following workshop exists:
      | name                | online |
      | Test-Driven Haskell | true   |
    When I view all products
    And I follow "Test-Driven Haskell"
    Then I should not see the date range
