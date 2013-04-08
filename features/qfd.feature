Feature: QFD
  As a user 
  I want to create a QFD
  So that I can create great products

  Scenario: User creates a QFD
    Given that I'm logged in
    And I'm on the new QFD form
    When I fill in the following:
      | Name | Test QFD |
    And I press "Create QFD"
    Then I should see the QFD's first HOQ's name, "Example HOQ"
    And I should see a flash notice indicating success

  Scenario: User views a QFD
    Given that I'm logged in
    And I've created a QFD
    When I go to the QFD's page
    Then I should see the QFD's first HOQ's name, "Example HOQ"

  Scenario: User deletes a QFD
    Given that I'm logged in
    And I've created a QFD
    When I delete the QFD
    Then I should see a flash notice indicating success

  Scenario: User views a QFD to which he doesn't have access
    Given that I'm logged in
    And another user has created a QFD
    When I visit the QFD
    Then I should see the permission denied page

  Scenario: Anonymous user views a QFD to which he doesn't have access
    Given I'm an anonymous user
    And another user has created a QFD
    When I visit the QFD
    Then I should see the permission denied page

  Scenario: Anonymous user views the QFD index
    Given I'm an anonymous user
    And another user has created a QFD
    When I go to the QFDs index
    Then I should see the public QFD index
    And I should see a recommendation to log in

  Scenario: User views the public QFD index
    Given I'm logged in
    When I go to the public QFDs index
    Then I should see the public QFD index
    And I should see a link to my personalized QFDs index