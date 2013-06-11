Feature: View topics

  Scenario: View topics
    Given a featured topic named "Topic 1"
    And a topic named "Topic 2"
    And a featured topic named "Topic 3"
    When I go to the topics page
    Then I should see "Topic 1" within "#topics-list"
    Then I should not see "Topic 2" within "#topics-list"
    Then I should see "Topic 3" within "#topics-list"

  Scenario: Navigate to a topic
    Given the following topics exist:
      | name    | summary         | featured | keywords    |
      | Topic 1 | The first topic | true     | ruby, rails |
    When I go to the topics page
    And I follow "Topic 1"
    Then I should see "Topic 1" within ".subject"
    Then the meta description should be "The first topic"
    Then the meta keywords should be "ruby, rails"
    Then the page title should be "Learn Topic 1"

  Scenario: View a topic's related products
    Given a featured topic named "Topic 1"
    And a workshop named "workshop 1" for topic "Topic 1"
    And a "book" product named "Book 1" for topic "Topic 1"
    And a "video" product named "Video 1" for topic "Topic 1"
    And a "video" inactive product named "Video Inactive" for topic "Topic 1"
    And an article for topic "Topic 1"
    When I go to the topics page
    And I follow "Topic 1"
    Then I should see "workshop 1" within "aside .workshop"
    Then I should see "Book 1" within "aside .book"
    Then I should see "Video 1" within "aside .video"
    Then I should not see "Video Inactive" within "aside"
    And I follow "View related Giant Robots articles"
    Then I should see "workshop 1" within "aside .workshop"
    Then I should see "Book 1" within "aside .book"
    Then I should see "Video 1" within "aside .video"

  Scenario: View the type for a topic's related products
    Given a featured topic named "Rails"
    And an in-person workshop named "In-Person Rails" for topic "Rails"
    And an online workshop named "Online Rails" for topic "Rails"
    When I go to the topics page
    And I follow "Rails"
    Then I should see that the related workshop "In-Person Rails" is in-person
    And I should see that the related workshop "Online Rails" is online
