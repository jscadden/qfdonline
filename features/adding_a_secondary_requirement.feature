Feature: Adding a secondary requirement
  As a user
  I want to add secondary requirements to my HOQ
  So that I can prioritize my workflow

  Background:
    Given I'm logged in as "user"
    And I've a QFD named "Add Sec Req Test"
    And I visit the QFD named "Add Sec Req Test"

  @javascript
  Scenario: User adds a secondary requirement via the context menu
    When I right click on the column #1's number cell
    Then I should see the column context menu
    When I click on "Insert After" in the column menu
    Then I should see a new secondary requirement

  @javascript
  Scenario: User adds a secondary requirement via the add secondary requirement icon
    When I mouse over the last column's number cell
    Then I should see the add secondary requirement arrow
    When I click the add secondary requirement arrow
    Then I should see a new secondary requirement
