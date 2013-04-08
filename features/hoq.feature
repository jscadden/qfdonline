Feature: HOQ
  As a user
  I want to create houses of quality within my QFDs
  So that I can determine work priorities

  Background:
    Given that I'm logged in
    And I've a QFD 

  Scenario: User views the new HOQ form
    When I visit the QFD
    And I follow "New HOQ"
    Then I should be on the new HOQ form

  Scenario: User creates a new HOQ
    When I am on the new HOQ form
    And I create a new HOQ
    Then I should see the new HOQ's name

  @javascript @slow
  Scenario: Primary requirements are inherited from the previous HOQ
    Given I visit the QFD
    And I've added a secondary requirement "Make it lighter" to the HOQ
    When I create a new HOQ
    Then the new HOQ should have a primary requirement "Make it lighter"

  @javascript
  Scenario: User renames a HOQ
    When I visit the QFD
    And I click the rename link and enter "Foo Bar"
    Then I should see the renamed HOQ's name
    