Feature: Editing a student of a course

  @javascript
  Scenario: Mark an unpaid student as paid
    Given I am signed in as an admin
    And a visitor named "Francis" registered for "Test-driven Marriage" on 2012-05-07
    When I mark "Francis" as paid for "Test-driven Marriage" on 2012-05-07
    Then "Francis" should be marked as paid for "Test-driven Marriage" on 2012-05-07
