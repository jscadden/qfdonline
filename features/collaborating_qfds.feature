Feature: Collaborating QFDs
  As a user
  I want to have collaborators viewing or working on my QFDs
  So I can get work done better and faster

  Background:
    Given a collab_test user exists

  @javascript
  Scenario: User edits a collaborative QFD's requirement
    Given that I'm logged in as "collab_test"
    When I visit a collaborative QFD's page
    And I change the name of a requirement to "Fooberries"
    Then I should see the name of a requirement is "Fooberries"
    
  @javascript
  Scenario: User tries to edit a read-only collaborative QFD's requirement
    Given that I'm logged in as "collab_test"
    And my invitations are all read-only
    When I visit a collaborative QFD's page
    And I double click on the name of a requirement
    Then I should not be presented with an input

  Scenario: User views a collaborative QFD in their QFDs index
    Given that I'm logged in as "collab_test"
    And I can collaborate on a QFD named "Collab QFD"
    When I go to my QFDs index
    Then I should see a link to "Collab QFD" with "Collaborator" permissions

  Scenario: User views a read-only collaborative QFD in their QFDs index
    Given that I'm logged in as "collab_test"
    And I can collaborate read-only on a QFD named "Collab QFD (RO)"
    When I go to my QFDs index
    Then I should see a link to "Collab QFD (RO)" with "Collaborator (RO)" permissions
