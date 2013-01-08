Feature: Products include support

  Scenario: Viewing products of different types
    Given the following products exist:
      | name     | product_type | short_description |
      | Book     | book         | An awesome book   |
      | Video    | video        | An amazing video  |
      | Workshop | workshop     |                   |
    When I view the product "Book"
    Then I should see "Every book includes support"
    Then the meta description should be "An awesome book"
    Then the page title should be "Book: a book by thoughtbot"
    When I view the product "Video"
    Then I should see "Every video includes support"
    Then the meta description should be "An amazing video"
    Then the page title should be "Video: a video by thoughtbot"
    When I view the product "Workshop"
    Then I should see "Every workshop includes support"
    Then the page should use the default meta description
    Then the page title should be "Workshop: a workshop by thoughtbot"

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

  Scenario: View online workshop and see callout to take in-person workshop
    Given the following workshops exist:
      | name                        | online |
      | Workshop with the same name | false  |
      | Workshop with the same name | true  |
    When I view the online workshop "Workshop with the same name"
    Then I should see a product alert for the in-person workshop
    And I should see a link to the in-person workshop

  Scenario: View online workshop without an in-person version
    Given the following workshop exists:
      | name            | online |
      | Online Workshop | true   |
    When I view the online workshop "Online Workshop"
    Then I should not see a product alert

  Scenario: View in-person workshop and see callout to take online workshop
    Given the following workshops exist:
      | name                        | online |
      | Workshop with the same name | true   |
      | Workshop with the same name | false  |
    When I view the in-person workshop "Workshop with the same name"
    Then I should see a product alert for the online workshop
    And I should see a link to the online workshop

  Scenario: View in-person workshop with no online workshop
    Given the following workshop exists:
      | name               | online |
      | In-person Workshop | false  |
    When I view the in-person workshop "In-person Workshop"
    Then I should not see a product alert
