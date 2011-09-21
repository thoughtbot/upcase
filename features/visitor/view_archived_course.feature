Feature: Visitor view archived course
  In order to make sure that I don't see outdated information
  As a visitor
  I should not be able to access the archived course

  @allow-rescue
  Scenario: View an archived course
    Given a course exists with a name of "Test-Driven Sleeping"
    And a course "Test-Driven Sleeping" is maked as unpublic
    When I go to the home page
    Then I should not see "Test-Driven Sleeping"
    When I go to the course page of "Test-Driven Sleeping"
    Then I should see a page not found error

  @allow-rescue
  Scenario: View a section in archived course
    Given today is June 10, 2010
    And a course exists with a name of "Test-Driven Sleeping"
    And the following section exists:
      | id   | course                     | starts on     | ends on       |
      | 1234 | name: Test-Driven Sleeping | June 13, 2010 | June 16, 2010 |
    And a course "Test-Driven Sleeping" is maked as unpublic
    When I go to the section page of "Test-Driven Sleeping"
    Then I should see a page not found error
