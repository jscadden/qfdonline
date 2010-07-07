Feature: Primary requirements

  As a user
  I want to manage my HOQs' requirements
  So that I can prioritize my development

  @javascript
  Scenario: User deletes a primary requirement
    Given I'm logged in
    And I've a QFD
    And I'm viewing the QFD
    And the QFD's first HOQ's first primary requirement is named "To Be Deleted"
    When I right click on the row #1's number cell
    Then I should see the row context menu
    When I click on "Delete" in the row menu
    Then I shouldn't see a primary requirement named "To Be Deleted"
