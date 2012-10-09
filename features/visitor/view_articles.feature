Feature: View articles

  Scenario: Navigate to articles
    Given a featured topic named "Topic 1"
    And an article for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    And I follow "View all Topic 1 articles"
    Then I should see the article
