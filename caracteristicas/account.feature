Característica: Account
  Para realizar las acciones oportunas en la cuenta de un usuario de la aplicación
  Como usuario
  Quiero poder cambiar la contraseña, eliminar los datos de mi cuenta

  @with_selenium
  Escenario: Cambio de contraseña
    Dado que existe un usuario registrado y activado como "login/login@login.com/password"
	Cuando visito /login
      Y relleno los datos de sesión como "login/password"
    Entonces pulso el enlace "Account"
      Y veo el texto "Change password"
    Cuando relleno "Current password" con "password"
      Y relleno "New password" con "otropassword"
      Y relleno "Confirm new password" con "otropassword"
      Y pulso el botón "Change"
    Entonces veo el texto "Password Changed"

  @with_selenium
  Escenario: Eliminación completa de la cuenta
    Dado que existe un usuario registrado y activado como "login/login@login.com/password"
	Cuando visito /login
      Y relleno los datos de sesión como "login/password"
    Entonces pulso el enlace "Account"
      Y veo el texto "Remove Account"
      Y pulso el enlace "Your account has been destroyed. Thank you for using our site."
    Entonces veo el texto "Password Changed"
