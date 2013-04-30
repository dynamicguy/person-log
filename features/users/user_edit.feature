Feature: Edit User
  As a registered user of the website
  I want to edit my user profile
  so I can change my username

  Background:
    Given I am logged in

  Scenario: I sign in and edit my account
    When I edit my account details
    Then I should see an account edited message
