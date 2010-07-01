Feature: Invite a collaborator
  As a user
  I want to invite others to work on my QFD
  So that we can share ideas

  Background:
    Given an invitations_test user exists

  Scenario: User goes to the invite a collaborator form
    Given I'm logged in as "invitations_test"
    And I'm on the qfds index
    When I follow "Invite A Collaborator"
    Then I should see the invite a collaborator form

  Scenario: User invites a collaborator
    Given I'm logged in as "invitations_test"
    When I fill in the invite a collaborator form
    And I press "Invite"
    Then I should see a flash notice matching "Invitation sent"
    And an invitation email should be sent
    And the invitation email should include an invitation link

  Scenario: Anonymous user accepts an invitation
    Given an unaccepted invitation
    When I follow an invitation link
    And I follow "Click here to register"
    And I fill out the signup form
    And I press "Register"
    Then I should see a collaboration invitation
    When I press "Accept"
    Then I should see the QFD's first HOQ's name, "Example HOQ"
    
  Scenario: Existing user accepts an invitation
    Given an unaccepted invitation
    And an invited_test user exists
    When I follow an invitation link and log in as "invited_test"
    Then I should see a collaboration invitation
    When I press "Accept"
    Then I should see the QFD's first HOQ's name, "Example HOQ"
    
  Scenario: User accepts his own invitation
    Given an unaccepted invitation
    And I'm logged in as "invitations_test"
    When I follow an invitation link
    Then I should see a collaboration invitation
    When I press "Accept"
    Then I should see an explanation of the failure
    
  Scenario: User invites a user twice
    Given an unaccepted invitation
    And I'm logged in as "invitations_test"
    When I fill in the invite a collaborator form
    And I press "Invite"
    Then I should see an explanation of the failure

  Scenario: Invited user should see a collaborator's QFD in her index
    Given an invited_test user exists
    And an accepted invitation
    And I'm logged in as "invited_test"
    Then I should see a link to the invited qfd

  Scenario: User invites a collaborator (read-only)
    Given I'm logged in as "invitations_test"
    When I fill in the invite a collaborator form
    And I check "Read only"
    And I press "Invite"
    Then I should see a flash notice matching "Invitation sent"
    And an invitation email should be sent
    And the invitation email should include an invitation link
