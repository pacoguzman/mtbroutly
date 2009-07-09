Feature: Log In
  In order to acceder a las zonas restringidas de la aplicación
  As a un usuario
  I want ser capaz de loguearme

   Scenario: El usuario no está registrado
     Given no user exists as "login"
     When I go to the login page
     And I fill the login form with "login/password"
     Then I should see "Incorrect username or password"
     Then no debo estar logueado

  Scenario: El usuario no ha confirmado su cuenta
    Given an registered user exists as "login/login@login.com/password"
    When I go to the login page
    And I fill the login form with "login/password"
    Then I should see "Incorrect username or password"
    And no debo estar logueado
    And me gustaría ver el texto "Please confirm your account before"

  Scenario: El usuario introduce datos incorrectos
    Given que existe un usuario registrado y activado como "login/login@login.com/password"
    When I go the login page
    And I fill the login form with "log/pass"
    Then I should see "Incorrect username or password"
    And no debo estar logueado

  Scenario: EL usuario se loguea correctamente
    Given que existe un usuario registrado y activado como "login/login@login.com/password"
    When I go to the login page
    And I fill the login form with "login/password"
    Then I should see "Logged in successfully"
    And debo estar logueado

  Scenario: El usuario se loguea correctamente y marca "recordarme"
    Given que existe un usuario registrado y activado como "login/login@login.com/password"
    When I go to the login page
    And relleno los datos de sesión pulsando "recuerda me" como "login/password"
    When I should see "Logged in successfully"
    And debo estar logueado
    When I go back to the login page
    Then I have to be logged in
 