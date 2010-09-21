Feature: Adding a course

  Scenario: Add a course with blank required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    And I press the button to create a course
    Then I should see the admin header
    And I see the "can't be blank" error for the following fields:
      | course name        |
      | course description |
      | course price       |
      | start time         |
      | end time           |
      | location           |

  Scenario: Add a course with the required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    Then I should see the admin header
    When I fill in the course name with "Test-Driven Haskell"
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
    When I go to the admin page
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

  Scenario: Add a course with a FAQ
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    And I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I fill in the question 1 with "Do I need a helmet?"
    And I fill in the answer 1 with "Of course."
    And I press the button to create a course
    Then I see the successful course creation notice
    When I follow the link to edit the course "Haskell"
    Then the question 1 field should contain "Do I need a helmet?"
    And the answer 1 field should contain "Of course."

  @javascript
  Scenario: Add a course with more than one FAQ
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    And I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I follow "Add Question"
    And I fill in the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
    And I press the button to create a course
    Then I see the successful course creation notice
    When I follow the link to edit the course "Haskell"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |

  Scenario: Add a course with a resource
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    And I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I fill in the resource 1 with "Github"
    And I fill in the url 1 with "http://github.com"
    And I press the button to create a course
    Then I see the successful course creation notice
    When I follow the link to edit the course "Haskell"
    Then the resource 1 field should contain "Github"
    And the url 1 field should contain "http://github.com"

  @javascript
  Scenario: Add a course with more than one resource
    Given I am signed in as an admin
    When I go to the admin page
    And I follow the link to create a new course
    And I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I follow "Add Resource"
    And I fill in the following resources:
      | name   | url                    |
      | Github | http://github.com      |
      | Rails  | http://rubyonrails.org |
    And I press the button to create a course
    Then I see the successful course creation notice
    When I follow the link to edit the course "Haskell"
    Then I see the following resources:
      | name   | url                    |
      | Github | http://github.com      |
      | Rails  | http://rubyonrails.org |


  Scenario: Adding a course as a non-admin
    Given I am signed in as a student
    When I go to the list of courses
    Then I see the permission denied error

