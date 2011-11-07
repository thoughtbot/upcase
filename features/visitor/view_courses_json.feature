Feature: View courses json

  Scenario: Requesting the json
    Given the following courses exist:
      | name | public |
      | Foo  | true   |
      | Bar  | false  |
    When I go to the courses json page
    Then I should see the json for the public courses

  Scenario: Requesting the json with a callback
    Given the following courses exist:
      | name | public |
      | Foo  | true   |
      | Bar  | false  |
    When I go to the courses json page with the callback "foo"
    Then I should see the json for the public courses with the callback "foo"
