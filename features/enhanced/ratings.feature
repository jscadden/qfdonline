Feature: CRUD ratings

  Background:
    Given a ratings_test user exists

  Scenario: User creates a rating
    Given that I'm logged in as "ratings_test"
    And I visit the HOQ's page
    And I double click on the first rating's cell
    And I select "9" from "rating[value]"
    And I wait for 1 second
    Then I should see "9" in the rating's cell

  Scenario: User increases a row's maximum rating
    Given that I'm logged in as "ratings_test"
    And I visit the HOQ's page
    And I double click on the first rating's cell
    And I select "9" from "rating[value]"
    And I wait for 1 second
    Then I should see "9" in the rating's row's maximum cell
