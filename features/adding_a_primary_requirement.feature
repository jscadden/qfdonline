Feature: Adding a primary requirement
  As a user
  I want to add primary requirements to my HOQ
  So that I can prioritize my workflow

  Background:
    Given I'm logged in as "user"
    And I've a QFD named "Add Pri Req Test"
    And I visit the QFD named "Add Pri Req Test"

  @javascript
  Scenario: User adds a primary requirement via the context menu
    When I right click on the row #1's number cell
    Then I should see the row context menu
    When I click on "Insert Below" in the row menu
    Then I should see a new primary requirement

  @javascript
  Scenario: User adds a primary requirement via the add primary requirement icon
    When I mouse over the last row's number cell
    Then I should see the add primary requirement arrow
    When I click the add primary requirement arrow
    Then I should see a new primary requirement
