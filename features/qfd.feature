Feature: Quality Function Deployment

  As a user
  I want to create and manage QFDs
  So that I can create great products

  Scenario: User creates a new QFD
    Given that I'm on the new QFD form
    When I fill in the following:
      | Name     | Test QFD |
    And I press "Create QFD"
    Then I should be on the new QFD's page
    And I should see a flash notice indicating success

  Scenario: User views a list of QFDs
    Given that a QFD exists
    When I visit the QFD index
    Then I should see the QFD's name
    And a link to the QFD