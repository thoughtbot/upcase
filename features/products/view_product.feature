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
