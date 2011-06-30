Feature: View courses json

  Scenario: Requesting the json
    Given the following courses exist:
      | name |
      | Foo  |
      | Bar  |
    When I go to the courses json page
    Then I should see the json for the courses
