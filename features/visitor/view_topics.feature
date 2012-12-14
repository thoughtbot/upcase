Feature: View topics

  Scenario: Navigate to workshops
    Given the following course exists:
      | name                | promo_location |
      | Test-Driven Haskell | left           |
    When I go to the home page
    And I follow "REGISTER"
    Then I should see "Test-Driven Haskell"

  Scenario: Navigate to a book
    Given the following products exist:
      | name   | product_type | promo_location |
      | Book 1 | book         | middle         |
    When I go to the home page
    And I follow "READ"
    Then I should see "Book 1"

  Scenario: Navigate to a video
    Given the following products exist:
      | name         | product_type | promo_location |
      | Video 1      | video        | right          |
      | Video 2      | video        |                |
    When I go to the home page
    And I follow "WATCH"
    Then I should see "Video 1"

  Scenario: View topics
    Given a featured topic named "Topic 1"
    And a topic named "Topic 2"
    And a featured topic named "Topic 3"
    When I go to the home page
    Then I should see "Topic 1" within "#learn-topics-list"
    Then I should not see "Topic 2" within "#learn-topics-list"
    Then I should see "Topic 3" within "#learn-topics-list"

  Scenario: Navigate to a topic
    Given the following topics exist:
      | name    | summary         | featured |
      | Topic 1 | The first topic | true     |
    When I go to the home page
    And I follow "Topic 1"
    Then I should see "Topic 1" within ".learn-detail-logo"
    Then the meta description should be "The first topic"
    Then the page title should be "Learn Topic 1"

  Scenario: View a topic's related products
    Given a featured topic named "Topic 1"
    And a course named "Course 1" for topic "Topic 1"
    And a "book" product named "Book 1" for topic "Topic 1"
    And a "video" product named "Video 1" for topic "Topic 1"
    And a "video" inactive product named "Video Inactive" for topic "Topic 1"
    And an article for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1"
    Then I should see "Course 1" within "aside"
    Then I should see "Book 1" within "aside"
    Then I should see "Video 1" within "aside"
    Then I should not see "Video Inactive" within "aside"
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

  Scenario: Learn about a topic
    Given a featured topic named "Ruby on Rails"
    And a trail-map for "ruby+on+rails"
    When I go to the home page
    And I follow "Ruby on Rails"
    And I should see a trail-map for "ruby+on+rails"
