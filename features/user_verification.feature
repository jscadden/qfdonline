Feature: User verification
  As a site administrator
  I want to verify that my users have given me a valid email address
  To prevent bots on the site

  Scenario: User receives a verification email
    Given I'm an anonymous user
    When I register
    Then I should receive a verification email

  Scenario: User verifies their email
    Given I've received a verification email
    When I follow the verification link
    Then I should be logged in
