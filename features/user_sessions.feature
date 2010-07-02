Feature: User Sessions

  As a user
  I should be able to log in and out of the system
  So that I can work on my QFDs authentically

  Scenario: User logs in
    Given a user with login "test" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Login    | test     |
      | Password | password |
    And I press "Log in"
    Then I should be logged in
    And I should see a flash notice indicating success
      		 
  Scenario: User logs out
    Given that I'm logged in
    When I visit the logout page
    Then I should be on the login page
    And I should see a flash notice indicating that I'm logged out

  Scenario: User mistypes their password
    Given a user with login "test" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Login    | test         |
      | Password | bad_password |
    And I press "Log in"
    Then I should see the login form
    And I should see an explanation of the failure
