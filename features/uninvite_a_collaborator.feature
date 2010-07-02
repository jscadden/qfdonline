Feature: Uninvite a collaborator
  As a user
  I want to revoke an invitation to work on my QFD
  So that I can control my QFD

  Background:
    Given an invitations_test user exists
    And an invited_test user exists
    And an unaccepted invitation
    When I follow an invitation link and sign up as a new user
    And I follow the verification link in the verification email
    Then I should see a collaboration invitation
    When I press "Accept"
    Then I should see the QFD's first HOQ's name, "Example HOQ"
    Then I log out

  Scenario: User revokes an invitation
    Given I'm logged in as "invitations_test"
    When I follow "Edit"
    And I check "qfd_invitations_attributes_0__delete"
    And I press "Save QFD"
    And I log out
    Given I'm logged in as "invited_test"
    Then I should not see a link to the invited qfd

