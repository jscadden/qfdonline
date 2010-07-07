Feature: Secondary requirements

  As a user
  I want to manage my HOQs' requirements
  So that I can prioritize my development

  @javascript
  Scenario: User deletes a secondary requirement
    Given I'm logged in
    And I've a QFD
    And I'm viewing the QFD
    And the QFD's first HOQ's first secondary requirement is named "To Be Deleted"
    When I right click on the column #1's number cell
    Then I should see the column context menu
    When I click on "Delete" in the column menu
    Then I shouldn't see a secondary requirement named "To Be Deleted"
