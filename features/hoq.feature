Feature: HOQ
  As a user
  I want to create houses of quality within my QFDs
  So that I can determine work priorities

  Background:
    Given that I'm logged in
    And I've created a QFD
    And I'm viewing the QFD

  Scenario: User views the new HOQ form
    When I follow "New HOQ"
    Then I should be on the new HOQ form

  Scenario: User creates a new HOQ
    Given I'm on the new HOQ form
    When I fill in the following:
      | name | Test HOQ |
    And I press "Create HOQ"
    Then I should be on the new HOQ's page
    And I should see a flash notice indicating success

  Scenario: Primary requirements are inherited from the previous HOQ
    Given I've created a HOQ
    And I've added a secondary requirement "Make it lighter" to the HOQ
    When I create a new HOQ
    Then the new HOQ should have a primary requirement "Make it lighter"