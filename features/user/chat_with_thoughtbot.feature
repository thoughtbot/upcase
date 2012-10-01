Feature: Chat with thoughtbot

  Scenario: A user who has purchased a product views chat link
    Given I am a user who has purchased a product
    And I visit my profile
    Then I should see a link to chat with thoughtbot
