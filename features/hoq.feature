Feature: House of Quality

  As a user
  I want to create and manage HOQs
  So that I can create great products

  Background:
    Given a QFD exists

  Scenario: User creates a new HOQ
    Given that I'm on the new HOQ form
    When I fill in the following:
      | Name     | Test HOQ |
    And I press "Create HOQ"
    Then I should be on the new HOQ's page
    And I should see a flash notice indicating success

  Scenario: User views a list of HOQs
    Given that a HOQ exists
    When I visit the HOQ's QFD
    Then I should see the HOQ's name
    And a link to the HOQ