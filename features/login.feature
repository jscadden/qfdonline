Feature: Login

  As a user
  I should be able to log in and out of the system
  So that I can work on my QFDs

  Scenario: User logs in
    Given a user with email "test@qfdonline.com" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Email    | test@qfdonline.com |
      | Password | password |
    And I press "Log in"
    Then I should be logged in
    And I should see a flash notice indicating success
      		 
  Scenario: User logs out
    Given a user with email "test@qfdonline.com" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Email    | test@qfdonline.com |
      | Password | password |
    And I press "Log in"
    And I should be logged in
    When I follow "Log out"
    Then I should be on the login page
    And I should see a flash notice indicating that I'm logged out

  Scenario: User mistypes their password
    Given a user with email "test@qfdonline.com" and password "password" exists
    When I visit the login page
    And I fill in the following:
      | Email    | test@qfdonline.com |
      | Password | bad_password |
    And I press "Log in"
    Then I should see the login form
    And I should see an explanation of the failure
