Feature: Addition
  In order to avoid silly mistakes
  As a math idiot 
  I want to be told the sum of two numbers

  Scenario Outline: Add two numbers
    Given I have entered <input_1> into the calculator
    And I have entered <input_2> into the calculator
    When I press add
    Then the result should be <output> on the screen

  Examples:
    | input_1 | input_2 | output |
    | 20      | 30      | 50     |
    | 2       | 5       | 7      |
    | 0       | 40      | 40     |
