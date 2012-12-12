Feature: Products include support

  Scenario: Viewing products of different types
    Given the following products exist:
      | name     | product_type |
      | Book     | book         |
      | Video    | video        |
      | Workshop | workshop     |
    When I view the product "Book"
    Then I should see "Every book includes support"
    When I view the product "Video"
    Then I should see "Every video includes support"
    When I view the product "Workshop"
    Then I should see "Every workshop includes support"

  Scenario: Viewing an inactive product
    Given the following product exists:
      | name | product_type | active |
      | Book | book         | false  |
    When I view the product "Book"
    Then I should not see "Purchase for Yourself"
    And I should see "This book is not currently available. Contact learn@thoughtbot.com for more information."

  Scenario: Viewing products with and without temporary sale prices
    Given the following products exist:
      | name  | product_type | active | discount_percentage | discount_title   |
      | Book  | book         | true   | 20                  | Special discount |
      | Video | book         | true   | 0                   | Special discount |
    When I view the product "Book"
    Then I should see "Book" discounted 20% with the text "Special discount"
    When I view the product "Video"
    Then I should see "Video" is not discounted
