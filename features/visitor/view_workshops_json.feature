Feature: View workshops json

  Scenario: Requesting the json
    Given the following workshops exist:
      | name | active |
      | Foo  | true   |
      | Bar  | false  |
    When I go to the workshops json page
    Then I should see the json for the active workshops

  Scenario: Requesting the json with a callback
    Given the following workshops exist:
      | name | active |
      | Foo  | true   |
      | Bar  | false  |
    When I go to the workshops json page with the callback "foo"
    Then I should see the json for the active workshops with the callback "foo"
