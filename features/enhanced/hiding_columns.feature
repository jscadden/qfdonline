Feature: Hide a column

  Background:
    Given a hiding_columns_test user exists

  Scenario: User hides a row
    Given that I'm logged in as "hiding_columns_test"
    And I visit the HOQ's page
    When I right click on the column #1's number cell
    And I click on "Hide" in the column menu
    And I wait for ajax
    Then I should not see column #1

  Scenario: User refreshes the page after hiding a column
    Given that I'm logged in as "hiding_columns_test"
    And I visit the HOQ's page
    When I right click on the column #1's number cell
    And I click on "Hide" in the column menu
    And I wait for ajax
    And I reload the page
    Then I should still not see column #1

