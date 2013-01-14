Feature: Accountant downloads purchases

  As an accountant
  In order to update my records
  I want to download purchases for the current and previous months

  Background:
    Given today is "February 1st, 2012 00:00:01 EST"
    And the following user exists:
      | email                | admin |
      | admin@example.com    | true  |
    And the following product exists:
      | name         |
      | Awesome book |
    And the following purchases exist for the product "Awesome book":
      | id | name   | email              | paid | payment_method |  paid_price | created_at              |
      | 1  | George | george@example.com | true | stripe         |  123        | 2012-01-05 11:27:00 EST |
      | 2  | Mike   | mike@example.org   | true | stripe         |  11         | 2012-02-01 00:00:01 EST |

  Scenario: Downloading this month's purchases
    When I sign in with "admin@example.com" and "password"
    And I am on the new admin page
    And I follow "Purchases"
    And I follow "Accounting"
    And I press "February"
    Then I should receive the following CSV file:
      | Id | Name | Email            | Paid | Payment method | Payment transaction | Purchaseable name | Price | Created at              |
      | 2  | Mike | mike@example.org | true | stripe         | ch_JQhSfU9Rz21owt   | Awesome book      | 11    | 2012-02-01 05:00:01 UTC |

  Scenario: Downloading last month's purchases
    When I sign in with "admin@example.com" and "password"
    And I am on the new admin page
    And I follow "Purchases"
    And I follow "Accounting"
    And I press "January"
    Then I should receive the following CSV file:
      | Id | Name   | Email              | Paid | Payment method | Payment transaction | Purchaseable name | Price | Created at              |
      | 1  | George | george@example.com | true | stripe         | ch_JQhSfU9Rz21owt   | Awesome book      | 123   | 2012-01-05 16:27:00 UTC |
