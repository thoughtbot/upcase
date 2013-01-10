Feature: View promoted products and workshops on home page
  Scenario: View featured products and workshops
    Given the following products exist:
      | name   | product_type | promo_location |
      | Book 1 | book         | middle         |
      | Book 2 | book         | right          |
    And the following workshops exist:
      | name                       | promo_location |
      | Test-Driven Machine Code   | left           |
    When I go to the home page
    Then "Book 1" should be in the middle promo location
    And "Book 2" should be in the right promo location
    And "Test-Driven Machine Code" should be in the left promo location
