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
      | Screencast 1 | screencast   |
      | Video 1      | video        |
    When I go to the home page
    And I follow "WATCH US"
    Then I should see "Screencast 1"
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
    Given a featured topic named "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then I should see "Topic 1" within ".learn-detail-logo"

  Scenario: View a topic with a workshop
    Given a featured topic named "Topic 1"
    And a course for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then the topic nav should include "WORKSHOPS"

  Scenario: View a topic with a book product
    Given a featured topic named "Topic 1"
    And a "book" product for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then the topic nav should include "BOOKS"

  Scenario: View a topic with a screencast product
    Given a featured topic named "Topic 1"
    And a "screencast" product for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then the topic nav should include "VIDEOS"

  Scenario: View a topic with a video product
    Given a featured topic named "Topic 1"
    And a "video" product for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then the topic nav should include "VIDEOS"

  Scenario: View a topic with an article
    Given a featured topic named "Topic 1"
    And an article for topic "Topic 1"
    When I go to the home page
    And I follow "Topic 1" within ".learn-text-box"
    Then the topic nav should include "BLOG POSTS"
