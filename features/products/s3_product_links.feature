Feature: Download products from S3
  As a customer
  I want to be able to download my book
  Even if I am not logged into github
  So that I can get it right away and not be confused

  Background:
    Given there is a github product named "Test GitHub"
    And I am a user who has purchased "Test GitHub"

  Scenario: Github products have links to S3 downloads
    When I visit the product page for "Test GitHub"
    Then I should see an S3 download link for "test-github.epub"
    And I should see an S3 download link for "test-github.pdf"
    And I should see an S3 download link for "test-github.mobi"

  Scenario: Product links are expiring
    When I visit the product page for "Test GitHub"
    Then the S3 link to "test-github.epub" should expire in the next hour
