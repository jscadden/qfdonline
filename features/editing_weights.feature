Feature: Inline Editing of Requirement Weights
  The weight of a primary requirement on the first House of Quality should be
  editable.

  Background:
    Given a editing_weights_test user exists

  @javascript
  Scenario: User edits the weight of a primary requirement
    Given that I'm logged in as "editing_weights_test"
    When I visit the HOQ's page
    And I double click on the first primary requirement's weight cell
    And I type "13\n"
    Then I should see "13" in the first primary requirement's weight cell
