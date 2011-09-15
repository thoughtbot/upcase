Feature: Viewing upcoming course details

  Scenario: Upcoming course price format
    Given the following course exists:
      | name                | location name     | location                        | start at | stop at  | price |
      | Test-Driven Haskell | Thoughtbot Office | 41 Winter St., Boston, MA 02108 | 09:00:00 | 12:00:00 | 1000  |
    When I go to the home page
    Then I should see "Test-Driven Haskell"
    When I follow "Test-Driven Haskell"
    Then I should see "$1,000"

  Scenario: Course has FAQ
    Given a course exists with a name of "Test-Driven Erlang"
    And the following questions exist:
      | course                   | question      | answer |
      | name: Test-Driven Erlang | What color?   | Blue   |
      | name: Test-Driven Erlang | Pets allowed? | No     |
    When I go to the home page
    And I follow "Test-Driven Erlang"
    And I see the question "What color?"
    And I see the answer "Blue"
    And I see the question "Pets allowed?"
    And I see the answer "No"
    And KISSmetrics receives the "Viewed Inactive Course" event with:
      | Course Name | Test-Driven Erlang |

  Scenario: Course does not have FAQ
    Given a course exists with a name of "Test-Driven Erlang"
    When I go to the home page
    And I follow "Test-Driven Erlang"
    Then I should not see "Frequently asked questions"
