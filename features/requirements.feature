Feature: Requirements

  As a user
  I want to create and manage requirements
  So that I can create great products

  Background:
    Given a QFD exists
    And the QFD has a HOQ
    
  @wip    	    
  Scenario: User creates a new requirement
    Given that I'm on the new requirement form
    When I fill in the following:
      | Name     | Test Requirement |
    And I press "Create Requirement"
    Then I should be on the new requirements's page
    And I should see a flash notice indicating success

  Scenario: User views a list of requirements
    Given the HOQ has a requirement
    When I visit the requirement's HOQ
    Then I should see the requirement's name
    And a link to the requirement