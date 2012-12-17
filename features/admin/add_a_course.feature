Feature: Adding a course

  Background:
    Given I am signed in as an admin
    And the following audience exists:
      | name       |
      | Developers |
    When I go to the admin page
    And I follow "New Course"

  Scenario: Add a course with blank required fields
    And I press "Create Course"
    And I see the "can't be blank" error for the following fields:
      | course name        |
      | course description |
      | course price       |
      | short description  |
      | start time         |
      | end time           |

  Scenario: Add a course with the required fields
    When I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I select "Developers" from "Audience"
    And I fill in the course price with "1900"
    And I fill in the course company price with "2000"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I press "Create Course"
    Then I see the successful course creation notice
    And I see the admin listing include a course named "Test-Driven Haskell"

  Scenario: Add a course with all the trimmings
    When I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I select "Developers" from "Audience"
    And I fill in the course price with "1900"
    And I fill in the course company price with "2000"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I fill in the max students with "16"
    And I check "Public"
    Then I should see an image with name "missing.jpg"
    When I attach an image name "test.jpg" to the course
    And I press "Create Course"
    Then I see the successful course creation notice
    And I see the admin listing include a course named "Test-Driven Haskell"
    When I follow "Test-Driven Haskell"
    Then I should see an image with name "test.jpg"

  Scenario: Add a course with a FAQ
    When I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I select "Developers" from "Audience"
    And I fill in the question 1 with "Do I need a helmet?"
    And I fill in the answer 1 with "Of course."
    And I press "Create Course"
    Then I see the successful course creation notice
    When I follow "Haskell"
    Then the question 1 field should contain "Do I need a helmet?"
    And the answer 1 field should contain "Of course."

  @selenium
  Scenario: Add a course with more than one FAQ
    And I fill in the required course fields
    And I fill in the course name with "Haskell"
    And I select "Developers" from "Audience"
    And I follow "Add Question"
    And I fill in the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
    And I press "Create Course"
    Then I see the successful course creation notice
    When I follow "Haskell"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |

  Scenario: Adding a course as a non-admin
    Given I am signed in as a student
    When I go to the list of courses
    Then I see the permission denied error
