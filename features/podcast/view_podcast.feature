Feature: View podcast episodes

  Scenario: View the list of published podcast episodes
    Given the following episodes exist:
      | title               | description   | duration |
      | Good episode        | this was good | 1210     |
      | Not so good episode | this was bad  | 0        |
    And the following future episode exists:
      | title          |
      | Future episode |
    When I go to the episodes page
    Then I should see "Good episode"
    And I should see "this was good"
    And I should see "20 minutes"
    And I should see "Not so good episode"
    And I should see "this was bad"
    And I should not see "Future episode"

  Scenario: View an individual podcast episode
    Given the following episode exists:
      | title               | description   | file_size | duration |
      | Good episode        | this was good | 13540249  | 1210     |
    When I go to the episodes page
    And I follow "Good episode"
    Then I should see information about the episode "Good episode"
    Then I should see an audio player for the episode "Good episode"
