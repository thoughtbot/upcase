Feature: View courses json

  Scenario: Requesting the json
    Given the following courses exist:
      | name |
      | Foo  |
      | Bar  |
    When I go to the courses json page
    Then I should see the json for the courses

  Scenario: Requesting the json with a callback
    Given the following courses exist:
      | name |
      | Foo  |
      | Bar  |
    When I go to the courses json page with the callback "foo"
    Then I should see the json for the courses with the callback "foo"
