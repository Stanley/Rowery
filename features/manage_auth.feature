Feature: Authentication
  In order to manage data sources
  A registered user
  Wants to log in and log out

  Scenario: Log in
    Given only user with email "staszek.wasiutynski@gmail.com", password "passwd"
      And I am on the login page
    When I fill in "username" with "staszek.wasiutynski@gmail.com"
      And I fill in "password" with "passwd"
      And I press "Log in"
    Then I should see "Zalogowany jako staszek.wasiutynski@gmail.com"

  Scenario: Log in failure (mail)
     Given only user with email "staszekwasiutynski@gmail.com", password "passwd"
      And I am on the login page
    When I fill in "username" with "staszek.wasiutynski@gmail.com"
      And I fill in "password" with "passwd"
      And I press "Log in"
    Then I should see "Authentication Required"

  Scenario: Log in failure (pass)
     Given only user with email "staszek.wasiutynski@gmail.com", password "password"
      And I am on the login page
    When I fill in "username" with "staszek.wasiutynski@gmail.com"
      And I fill in "password" with "passwd"
      And I press "Log in"
    Then I should see "Authentication Required"

  Scenario: Log out
    Given I am logged in as "staszek.wasiutynski@gmail.com"
    When I follow "log out"
    Then I should be on "the homepage"
      And I should see "logged out"