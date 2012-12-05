Feature: Watch video
  As a visitor
  I want to watch videos
  So that I can learn things

  Background:
    Given the following product exist:
      | name         | sku  | product_type | fulfillment_method |
      | Test Series  | TEST | video        | fetch              |
    And the video with wistia id "1194803" exists for "Test Series"
    And the video with wistia id "1194804" exists for "Test Series"

  Scenario: A visitor tries to watch video without paying first
    Given an unpaid purchase for "Test Series" with lookup "unpaid"
    When I go to the watch page for the purchase "unpaid"
    Then I should be on the home page
    When I go to the video list for the purchase "unpaid"
    Then I should be on the home page
    When I go to the video with id "1194803" for the purchase "unpaid"
    Then I should be on the home page
