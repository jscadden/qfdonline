Feature: Hide multiple columns

  Background:
    Given a hiding_columns_test user exists

  Scenario: User hides two rows
    Given that I'm logged in as "hiding_columns_test"
    And I visit the HOQ's page
    When I select two columns
    And I click on "Hide" in the column menu
    And I wait for ajax
    And I wait for 5 seconds
    Then I should not see the two selected columns
