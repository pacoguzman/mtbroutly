Característica: Log In
  Para acceder a las zonas restringidas de la aplicación
  Como un usuario
  Quiero ser capaz de loguearme
  
   Escenario: El usuario no está registrado
     Dado que no existe un usuario registrado como "login"
	 Cuando visito /login
	   Y relleno los datos de sesión como "login/password"
	 Entonces veo el texto "Incorrect username or password"
       Y no debo estar logueado	 

    Escenario: El usuario no ha confirmado su cuenta
      Dado que existe un usuario registrado como "login@login.com/login/password"
	  Cuando visito /login
        Y relleno los datos de sesión como "login/password"
	  Entonces veo el texto "Incorrect username or password"
	    Y no debo estar logueado
        Y me gustaría ver el texto "Please confirm your account before"
    
    Escenario: El usuario introduce datos incorrectos
      Dado que existe un usuario registrado y confirmado como "login/password"	
	  Cuando visito /login
        Y relleno los datos de sesión como "log/pass"
	  Entonces veo el texto "Incorrect username or password"
	    Y no debo estar logueado
   
    Escenario: EL usuario se loguea correctamente
      Dado que existe un usuario registrado y confirmado como "login/password"	
	  Cuando visito /login
        Y relleno los datos de sesión como "login/password"
	  Entonces veo el texto "Logged in successfully"
        Y debo estar logueado	  
		
	Escenario: El usuario se loguea correctamente y marca "recordarme"
      Dado que existe un usuario registrado y confirmado como "login/password"	
	  Cuando visito /login
        Y relleno los datos de sesión pulsando "recuerda me" como "login/password"
	  Entonces veo el texto "Logged in successfully"
	    Y debo estar logueado
	  Cuando regreso de nuevo
      Entonces me gustaría estar logueado
 