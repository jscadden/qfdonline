Feature: Requirements

  Background:
    Given that I'm logged in
    And I've created a QFD
    And I've created a HOQ

  Scenario: User can add a primary requirement
    Given I'm on the new primary requirement form
    When I fill in the following:
      | Name   | Test Pri Req |
      | Weight | 1.0          |
    And I press "Create Primary Requirement"
    Then I should be on the HOQ's page
    And I should see a primary requirement "Test Pri Req"
    And I should see a flash notice indicating success
