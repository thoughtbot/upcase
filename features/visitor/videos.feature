Feature: Watch video
  As a visitor
  I want to watch videos
  So that I can learn things

  Background:
    Given the following product exist:
      | name         | id | sku  | product_type | fulfillment_method |
      | Test Series  | 1  | TEST | video        | fetch              |
    And the following videos exist:
      | product_id | wistia_id |
      | 1          | 1194803   |
      | 1          | 1194804   |

  Scenario: A visitor tries to watch video without paying first
    Given an unpaid purchase for "Test Series" with lookup "unpaid"
    When I go to the watch page for the purchase "unpaid"
    Then I am redirected to the product page for "Test Series"
    When I go to the video list for the purchase "unpaid"
    Then I am redirected to the product page for "Test Series"
    When I go to the video with id "1194803" for the purchase "unpaid"
    Then I am redirected to the product page for "Test Series"
