Feature: Viewing the workshops page

  Scenario: Visitor can see workshop information
    Given the following workshop exists:
      | name                | short_description |
      | Test-Driven Haskell | Short Description |
    When I go to the workshop page of "Test-Driven Haskell"
    Then the meta description should be "Short Description"
    And the page title should be "Test-Driven Haskell: a workshop from thoughtbot"
    And I should see a product title of "Short Description"

  Scenario: Visitor sees a link to group purchase for online workshops
    Given today is January 11, 2013
    And the following workshop exists:
      | name            | online |
      | Online Workshop | true   |
    And the following section exists:
      | workshop              | starts_on    |
      | name: Online Workshop | 2013-01-12   |
    When I go to the workshop page of "Online Workshop"
    Then I should see "Purchase for Your Company"

  Scenario: Visitor does not see a link to group purchase for in-person workshops
    Given today is January 11, 2013
    And the following workshop exists:
      | name               | online |
      | In-Person Workshop | false  |
    And the following section exists:
      | workshop                 | starts_on    |
      | name: In-Person Workshop | 2013-01-12   |
    When I go to the workshop page of "In-Person Workshop"
    Then I should not see "Purchase for Your Company"
