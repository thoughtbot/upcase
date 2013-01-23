Feature: A/B test pricing

  # Scenario: Product with alternate individual and company prices
  #   Given the following product exists:
  #     | name | individual_price | company_price | alternate_individual_price | alternate_company_price |
  #     | Book | 1                | 2             | 3                          | 4                       |
  #   When I view the "Book" product with primary pricing
  #   Then I should see that the individual product price is "1"
  #   And I should see that the company product price is "2"
  #   And the product purchase variants should be primary
  #   When I view the "Book" product with alternate pricing
  #   Then I should see that the individual product price is "3"
  #   And I should see that the company product price is "4"
  #   And the product purchase variants should be alternate

  Scenario: In-Person workshop with alternate individual price
    Given the following workshop exists:
      | name    | individual_price | alternate_individual_price |
      | Haskell | 1                | 2                          |
    And the following section exists:
      | workshop      |
      | name: Haskell |
    When I view the "Haskell" workshop with primary pricing
    Then I should see that the individual workshop price is "1"
    When I view the "Haskell" workshop with alternate pricing
    Then I should see that the individual workshop price is "2"

  Scenario: Online workshop with alternate individual and company prices
    Given the following workshop exists:
      | name    | online | individual_price | company_price | alternate_individual_price | alternate_company_price |
      | Haskell | true   | 1                | 2             | 3                          | 4                       |
    And the following section exists:
      | workshop      |
      | name: Haskell |
    When I view the "Haskell" workshop with primary pricing
    Then I should see that the individual workshop price is "1"
    And I should see that the company workshop price is "2"
    When I view the "Haskell" workshop with alternate pricing
    Then I should see that the individual workshop price is "3"
    And I should see that the company workshop price is "4"

  Scenario: KISSmetrics tracks A/B test variant
    Given a workshop exists with a name of "Haskell"
    When I view the "Haskell" workshop with primary pricing
    Then KISSmetrics receives the following properties:
      | property         | value   |
      | workshop_pricing | primary |
    When I view the "Haskell" workshop with alternate pricing
    Then KISSmetrics receives the following properties:
      | property         | value     |
      | workshop_pricing | alternate |
