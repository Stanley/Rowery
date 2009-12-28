Feature: Manage users
  In order to provide clients with trustful data sources
  a user
  wants to register and manage his account
  
  Scenario: Register new user
    Given I am on the new user page
    When  I fill in "user_email" with "staszek.wasiutynski@gmail.com"
      And I fill in "user_password" with "passwd"
      And I fill in "user_password_confirmation" with "passwd"
      And I press "Sign up"
    Then I should see "Thanks for signing up"

  Scenario: Register new user whose e-mail is already registered
    Given the following users:
      | email                        | password  | password_confirmation |
      | staszekwasiutynski@gmail.com | secret    | secret                |
      And I am on the new user page
    When I fill in "user_email" with "staszekwasiutynski@gmail.com"
      And I fill in "user_password" with "passwd"
      And I fill in "user_password_confirmation" with "passwd"
      And I press "Sign up"
    Then I should see "There were problems"
      And I should see "This email is already in use"

  Scenario: Register new user with fake email
    Given I am on the new user page
    When I fill in "user_email" with "staszek.wasiutynski.gmail.com"
      And I fill in "user_password" with "passwd"
      And I fill in "user_password_confirmation" with "passwd"
      And I press "Sign up"
    Then I should see "There were problems"
      And I should see "Email has an invalid format"

  Scenario: Register new user with no password
    Given I am on the new user page
    When I fill in "user_email" with "staszek.wasiutynski@gmail.com"
      And I fill in "user_password" with ""
      And I fill in "user_password_confirmation" with ""
      And I press "Sign up"
    Then I should see "There were problems"
      And I should see "Password must not be blank"

  Scenario: Register new user with too short password
    Given I am on the new user page
    When I fill in "user_email" with "staszek.wasiutynski@gmail.com"
      And I fill in "user_password" with "abc"
      And I fill in "user_password_confirmation" with "abc"
      And I press "Sign up"
    Then I should see "There were problems"
      And I should see "Password must be between 5 and 15 characters long"

  Scenario: Register new user with wrong password confirmation
    Given I am on the new user page
    When I fill in "user_email" with "staszek.wasiutynski@gmail.com"
      And I fill in "user_password" with "passwd"
      And I fill in "user_password_confirmation" with "pass"
      And I press "Sign up"
    Then I should see "There were problems"
      And I should see "Password confirmation must be the same as password"

  Scenario: Change account settings
    Given I am logged in as "Stasiek@mail.com"
    When I follow "Stasiek@mail.com"
      And I fill in "email" with "new.email@domain.com"
      And I press "Update"
    Then I should see "success"

  Scenario: Change password
    Given I am logged in as "Stasio@gmail.com"
    When I follow "Stasio@gmail.com"
      And I fill in "password" with "passwd"
      And I fill in "password_confirmation" with "passwd"
      And I press "Update"
    Then I should see "success"

  Scenario: Change password failure
    Given I am logged in as "Stas@malpa.pl"
    When I follow "Stas@malpa.pl"
      And I fill in "password" with "passwd"
      And I fill in "password_confirmation" with "passwf"
      And I press "Update"
    Then I should see "There were problems"

#  Scenario: Delete user
#    Given the following users:
#      ||
#      ||
#      ||
#      ||
#      ||
#    When I delete the 3rd user
#    Then I should see the following users:
#      ||
#      ||
#      ||
#      ||
