@search
Feature: Search persons
  As a registered user of the website
  I want to search for persons
  so I can see list of persons for given keyword

  Background:
    Given I am logged in

  Scenario: I sign in and visit search page
    When I visit the home page
    Then I should see a form with a search box
    And I should see a search button

  @javascript
  Scenario: I sign in and search persons
    Given I have the following persons:
      | name          | email             | password | password_confirmation | confirmed_at               | published | address                         |
      | example user1 | user1@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user2 | user2@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user3 | user3@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user4 | user4@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user5 | user5@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user6 | user6@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
      | example user7 | user7@example.com | please   | please                | 2012-12-31 16:50:08.953797 | true      | Shamoli Park, Dhaka, Bangladesh |
    And I search for keyword "user"
    Then I should see search results page
    Then I wait for 20 seconds
