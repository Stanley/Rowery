Feature: Manage markers
  In order to display interesting points on the map
  a administrator
  wants to provide new markers and edit them
  
  Scenario: Access denied
    Given I am on the new marker page
    Then I should see "Authentication Required"

  Scenario: Create new marker
    Given I am logged in as "me@mail.com"
      And I follow "Dodaj parking"
    When I fill in "marker_name" with "My name"
      And I fill in "marker_description" with "My description"
      And I fill in "marker_lat" with "50.123"
      And I fill in "marker_lng" with "20.987"
      And I press "Utwórz"
    Then I should see "Sukces"

  Scenario: Reject duplicate
    Given I am logged in as "me@mail.com"
      And the following markers:
        | name        | description     | category | lat    | lng   |
        | Moja nazwa  | My description  | 7        | 50.001 | 20.2  |
      And I follow "Dodaj parking"
    When I fill in "marker_name" with "Moja nazwa"
      And I fill in "marker_description" with "Moj opis"
      And I fill in "marker_lat" with "50.123"
      And I fill in "marker_lng" with "20.987"
      And I press "Utwórz"
    Then I should see "Punkt o tej nazwie już istnieje"

  Scenario: Edit marker
    Given I am logged in as "me@mail.com"
      And the following markers:
        | name        | description     | category | lat    | lng   |
        | Moja nazwa  | My description  | 7        | 50.001 | 20.2  |
      And I am on markers page
      And I follow "Edytuj Moja nazwa"
    When I fill in "marker_name" with "Moja nowa nazwa"
      And I fill in "marker_description" with "Moj nowy opis"
      And I fill in "marker_lat" with "50.123"
      And I fill in "marker_lng" with "20.987"
      And I press "Zmień"
    Then I should see "Punkt został uaktualniony"

  Scenario: Edit marker, duplicated name
    Given I am logged in as "me@mail.com"
      And the following markers:
        | name            | description     | category | lat    | lng   |
        | Moja nazwa      | My description  | 7        | 50.001 | 20.2  |
        | Moja inna nazwa | My descr        | 6        | 50.011 | 20.8  |
      And I am on markers page
      And I follow "Edytuj Moja nazwa"
    When I fill in "marker_name" with "Moja inna nazwa"
      And I fill in "marker_description" with "Moj nowy opis"
      And I fill in "marker_lat" with "50.123"
      And I fill in "marker_lng" with "20.987"
      And I press "Aktualizuj"
    Then I should see "nazwa już istnieje"

  Scenario: Edit marker without providing coordinates
    Given I am logged in as "me@mail.com"
      And the following markers:
        | name            | description     | category | lat    | lng   |
        | Moja nazwa      | My description  | 7        | 50.001 | 20.2  |
        | Moja inna nazwa | My descr        | 6        | 50.011 | 20.8  |
      And I am on markers page
      And I follow "Edytuj Moja nazwa"
    When I fill in "marker_name" with "Moja nowa nazwa"
      And I fill in "marker_description" with "Moj nowy opis"
      And I fill in "marker_lat" with ""
      And I fill in "marker_lng" with ""
      And I press "Aktualizuj"
    Then I should see "uzupelnij pole lat"
      And I should see "uzupelnij pole lng"

  Scenario: Delete manage_markers
    Given the following markers:
        | name               | description     | category | lat    | lng   |
        | Moja nazwa         | My description  | 7        | 50.001 | 20.2  |
        | Moja inna nazwa    | My descr        | 6        | 50.011 | 20.8  |
        | Moja trzecia nazwa | My 3rd descr    | 5        | 50.111 | 21.3  |
      And I am on markers page
    When I delete the 3rd marker
    Then I should see "usunieto"
      And I should see the following markers:
        | name               | description     | category | lat    | lng   |
        | Moja nazwa         | My description  | 7        | 50.001 | 20.2  |
        | Moja inna nazwa    | My descr        | 6        | 50.011 | 20.8  |
