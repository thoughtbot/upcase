Feature: Adding a course

  Scenario: Add a product with the required fields
    Given I am signed in as an admin
    When I go to the admin page
    And I follow "Products"
    And I follow "New Product"
    When I fill in "Name" with "Test Product"
    And I fill in "Sku" with "TEST"
    And I fill in "Individual price" with "15"
    And I fill in "Company price" with "50"
    And I fill in "Fulfillment method" with "fetch"
    When I press "Create Product"
    Then I should see "Product successfully created"
    And I should see "Test Product"

  Scenario: Edit a product
    Given I am signed in as an admin
    And the following product exists:
      | name         |
      | Test Product |
    When I go to the admin page
    And I follow "Products"
    And I follow "Test Product"
    When I fill in "Name" with "New Name"
    When I press "Update Product"
    Then I should see "Product successfully updated"
    And I should see "New Name"

  @selenium
  Scenario: Edit downloads to product
    Given I am signed in as an admin
    And the following product exists:
      | name |
      | Test Product |
    When I go to the admin page
    And I follow "Products"
    And I follow "Test Product"
    When I add a download with file name "test.txt" and description "test file"
    When I press "Update Product"
    When I follow "Test Product"
    Then I should see "Remove this download"
    And I should see "test.txt" in input field
    And I should see "test file" in input field
    When I remove a download with file name "test.txt"
    When I press "Update Product"
    When I follow "Test Product"
    Then I should not see "test.txt"
