Feature: Public QFDs
  As a user
  I want to mark my QFDs as public
  So that I can share them with random people, who don't need to sign up in order to view them.

  Scenario: User marks a QFD as public
    Given that I'm logged in
    And I've created a QFD
    When I mark the QFD as public
    Then I should see an indicator that the QFD is public

  Scenario: User marks a QFD as private
    Given that I'm logged in
    And I've created a QFD
    When I mark the QFD as private
    Then I should not see an indicator that the QFD is public

  Scenario: Another user views a public QFD
    Given a public QFD named "Public QFD"
    And I'm logged in as "public_user"
    When I visit the QFD named "Public QFD"
    Then I should see the QFD's first HOQ's name, "Example HOQ"
