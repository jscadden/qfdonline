Feature: Login

  As a user
  I should be able to log in and out of the system
  So that I can work on my QFDs

  Scenario: User logs in
    Given a user with login "test" and password "password" exists
    And an anonymous user
    When I visit the login page
    And I fill in the following:
      | Login    | test     |
      | Password | password |
    And I press "Log in"
    And I wait for the page to load
    Then I should be on the root page
    And I should see a flash notice indicating success
      		 
  Scenario: User logs out
    Given a user with login "test" and password "password" exists
    And an anonymous user
    When I visit the login page
    And I fill in the following:
      | Login    | test     |
      | Password | password |
    And I press "Log in"
    And I wait for the page to load
    And I should be on the root page
    When I follow "Log out"
    And I wait for the page to load
    Then I should be on the login page
    And I should see a flash notice indicating that I'm logged out

  Scenario: User mistypes their password
    Given an anonymous user
    And a user with login "test" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Login    | test         |
      | Password | bad_password |
    And I press "Log in"
    And I wait for the page to load
    Then I should see the login form
    And I should see an explanation of the failure
