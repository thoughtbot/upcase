Feature: Adding a course

  @wip
  Scenario: Add a course with blank required fields
    Given I am signed in as an admin
    When I go to the home page
    And I follow the link to create a new course
    And I press the button to create a course
    Then I see the "can't be blank" error for the following fields:
      | name        |
      | description |
      | price       |
      | starts on   |
      | ends on     |
      | location    |

  Scenario: Add a course with the required fields
    Given I am signed in as an admin
    When I go to the home page
    And I follow the link to create a new course
    And I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the course price with "1900"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I fill in the location with "41 Winter St 02108"
    And I press the button to create a course
    Then I see the successful course creation notice
    And I see the admin listing include a course named "Test-Driven Haskell"

  Scenario: Add a course with all the trimmings
    Given I am signed in as an admin
    When I go to the home page
    And I follow the link to create a new course
    And I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the course price with "1900"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I fill in the location name with "thoughtbot"
    And I fill in the location with "41 Winter St 02108"
    And I fill in the max students with "16"
    And I fill in the terms of service with "You are stuck here"
    And I fill in the reminder email text with "This is really happening"
    And I check that the course is public
    And I press the button to create a course
    Then I see the successful course creation notice
    And I see the admin listing include a course named "Test-Driven Haskell"

  @wip
  Scenario: Add a course with a FAQ
    Given I am signed in as an admin
    When I go to the home page
    And I follow the link to create a new course
    And I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the course price with "1900"
    And I select the start time as "09:00"
    And I select the end time as "17:00"
    And I fill in the location with "41 Winter St 02108"
    And I fill in the question 1 with "Do I need a helmet?"
    And I fill in the answer 1 with "Of course."
    And I press the button to create a course
    Then I see the successful course creation notice
    And I see the course named "Test-Driven Haskell"

  @wip
  Scenario: Adding a course as a non-admin
