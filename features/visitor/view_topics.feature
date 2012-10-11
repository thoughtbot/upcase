Feature: View topics

  Scenario: Navigate to workshops
    Given a course exists with a name of "Test-Driven Haskell"
    When I go to the home page
    And I follow "FIND A WORKSHOP"
    Then I should see "Test-Driven Haskell"

  Scenario: Navigate to books
    Given the following products exist:
      | name   | product_type |
      | Book 1 | book         |
    When I go to the home page
    And I follow "READ ON"
    Then I should see "Book 1"

  Scenario: Navigate to videos
    Given the following products exist:
      | name         | product_type |
      | Video 1      | video        |
      | Video 2      | video        |
    When I go to the home page
    And I follow "WATCH US"
    Then I should see "Video 1"
    Then I should see "Video 2"

  Scenario: View topics
    Given a featured topic named "Topic 1"
    And a topic named "Topic 2"
    And a featured topic named "Topic 3"
    When I go to the home page
    Then I should see "Topic 1" within "#learn-topics-list"
    Then I should not see "Topic 2" within "#learn-topics-list"
    Then I should see "Topic 3" within "#learn-topics-list"

  Scenario: Navigate to a topic
    Given a featured topic named "Topic 1"
    When I go to the home page
    And I follow "Topic 1"
    Then I should see "Topic 1" within ".learn-detail-logo"

  Scenario: View a topic's related products
    Given a featured topic named "Topic 1"
    And a course named "Course 1" for topic "Topic 1"
    And a "book" product named "Book 1" for topic "Topic 1"
    And a "video" product named "Video 1" for topic "Topic 1"
    And an article for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1"
    Then I should see "Course 1" within "aside"
    Then I should see "Book 1" within "aside"
    Then I should see "Video 1" within "aside"
    And I follow "View all Topic 1 articles"
    Then I should see "Course 1" within "aside"
    Then I should see "Book 1" within "aside"
    Then I should see "Video 1" within "aside"

  Scenario: View a topic with an article
    Given a featured topic named "Topic 1"
    And an article for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1"
    Then the related reading section should include the article.
