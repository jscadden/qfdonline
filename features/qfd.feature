Feature: QFD
  As a user 
  I want to create a QFD
  So that I can create great products

  Scenario: User creates a QFD
    Given that I'm logged in
    And I'm on the new QFD form
    When I fill in the following:
      | Name | Test QFD |
    And I press "Create QFD"
    Then I should be on the new QFD's page
    And I should see a flash notice indicating success

