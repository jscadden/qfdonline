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
    Then I should see the QFD's first HOQ's name, "Example HOQ"
    And I should see a flash notice indicating success

  Scenario: User views a QFD
    Given that I'm logged in
    And I've created a QFD
    When I go to the QFD's page
    Then I should see the QFD's first HOQ's name, "Example HOQ"
