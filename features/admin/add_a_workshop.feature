Feature: Adding a workshop

  Background:
    Given I am signed in as an admin
    And the following audience exists:
      | name       |
      | Developers |
    When I go to the admin page
    And I follow "New Workshop"

  Scenario: Add a workshop with blank required fields
    And I press "Create Workshop"
    And I see the "can't be blank" error for the following fields:
      | workshop name        |
      | workshop description |
      | workshop price       |
      | short description    |
      | start time           |
      | end time             |

  Scenario: Add a workshop with the required fields
    When I fill in the workshop name with "Test-Driven Haskell"
    And I fill in the workshop description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I select "Developers" from "Audience"
    And I fill in the workshop price with "1900"
    And I fill in the workshop company price with "2000"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
    And I see the admin listing include a workshop named "Test-Driven Haskell"

  Scenario: Add a workshop with all the trimmings
    When I fill in the workshop name with "Test-Driven Haskell"
    And I fill in the workshop description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I select "Developers" from "Audience"
    And I fill in the workshop price with "1900"
    And I fill in the workshop company price with "2000"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
    And I fill in the max students with "16"
    And I check "Public"
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
    And I see the admin listing include a workshop named "Test-Driven Haskell"

  Scenario: Add a workshop with a FAQ
    When I fill in the required workshop fields
    And I fill in the workshop name with "Haskell"
    And I select "Developers" from "Audience"
    And I fill in the question 1 with "Do I need a helmet?"
    And I fill in the answer 1 with "Of course."
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
    When I follow "Haskell"
    Then the question 1 field should contain "Do I need a helmet?"
    And the answer 1 field should contain "Of course."

  @selenium
  Scenario: Add a workshop with more than one FAQ
    And I fill in the required workshop fields
    And I fill in the workshop name with "Haskell"
    And I select "Developers" from "Audience"
    And I follow "Add Question"
    And I fill in the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
    When I follow "Haskell"
    Then I see the following questions:
      | question            | answer          |
      | Do you wear pants?  | Define "Pants." |
      | Do I need a helmet? | Of course.      |

  Scenario: Adding a workshop as a non-admin
    Given I am signed in as a student
    When I go to the list of workshops
    Then I see the permission denied error
