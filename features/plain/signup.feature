Feature: Describiendo el registro de usuarios
  In order que el usuario puede acceder a las zonas restringidas de la aplicación
  As a un visitante
  I want que los usuarios puedan registrarse en la aplicación
  
  Scenario: Registrarse sign-up con datos incorrectos
    When I go to the signup page
    And I fill the form of signup as "login@login.com/login/password/otro_password"
	Then I should see "error prohibited"
    And no debo estar logueado
	  
  Scenario: Registrarse sign-up con datos correctos
    Given que no existe un usuario registrado como "pacoguzman"
	When visito /signup
	And relleno los datos de registro como "login@login.com/login/password/password"
	Then debo ver el texto "Thanks for signing up"
    And no debo estar logueado
	And debe enviarse un mensaje para la confirmación a la dirección "pacoguzmanp@gmail.com"
	  
  Scenario: Confirmación de la cuenta
    Given que existe un usuario registrado como "pacoguzman/pacoguzmanp@gmail.com/pacoguzman"
    When sigo el link de confirmación enviado a "pacoguzman"
    Then debo estar logueado
	And debo ver el texto "Signup complete!"