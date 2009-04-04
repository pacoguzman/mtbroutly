Característica: Describiendo el registro de usuarios
  Para que el usuario puede acceder a las zonas restringidas de la aplicación
  Como un visitante
  Quiero que los usuarios puedan registrarse en la aplicación
  
  Escenario: Registrarse sign-up con datos incorrectos
    Cuando visito /signup
      Y relleno los datos de registro como "login@login.com/login/password/otro_password"
	Entonces veo el texto "error prohibited"
      Y no debo estar logueado	
	  
  Escenario: Registrarse sign-up con datos correctos
    Dado que no existe un usuario registrado como "pacoguzman"
	Cuando visito /signup
	  Y relleno los datos de registro como "login@login.com/login/password/password"
	Entonces debo ver el texto "Thanks for signing up"
      Y no debo estar logueado
	  Y debe enviarse un mensaje para la confirmación a la dirección "pacoguzmanp@gmail.com"
	  
  Escenario: Confirmación de la cuenta
    Dado que existe un usuario registrado como "pacoguzman/pacoguzmanp@gmail.com/pacoguzman"
    Cuando sigo el link de confirmación enviado a "pacoguzman"
    Entonces debo estar logueado
	  Y debo ver el texto "Signup complete!"