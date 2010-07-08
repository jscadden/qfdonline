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

  @javascript
  Scenario: User cuts and pastes a secondary requirement
    Given I'm logged in
    And I've a QFD with 2 secondary requirements
    And I'm viewing the QFD
    And the QFD's first HOQ's first secondary requirement is named "To Be Cut"
    When I right click on column #1's number cell
    And I click on "Cut" in the column menu
    And I right click on column #2's number cell
    And I click on "Paste After" in the column menu
    Then I should see that column #2's requirement is named "To Be Cut"
