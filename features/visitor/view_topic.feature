Feature: Visitor views topic

  In order to easily navigate through blog content
  As a visitor
  I want to view topics and articles

  Scenario: View list of topics
    Given a topic exists
    When I am on the topics page
    Then I should see the topic

  Scenario: View topic page
    Given a topic exists
    And a related article exists
    When I am on the related topic page
    Then I should see the topic page
    And I should see the related article

  @javascript
  Scenario: Search topics
    Given the following topics exist:
      | name         |
      | Apple        |
      | Orange       |
    When I am on the topics page
    Then I should see "Apple"
    And I should see "Orange"
    And I search for "app"
    And "Orange" should not be visible
