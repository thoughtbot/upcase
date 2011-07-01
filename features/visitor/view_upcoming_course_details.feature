Feature: Viewing upcoming course details

  Scenario: Course has FAQ
    Given a course exists with a name of "Test-Driven Erlang"
    And the following questions exist:
      | course                   | question      | answer |
      | name: Test-Driven Erlang | What color?   | Blue   |
      | name: Test-Driven Erlang | Pets allowed? | No     |
    When I go to the home page
    And I follow "Test-Driven Erlang"
    Then I should see "Frequently asked questions"
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
