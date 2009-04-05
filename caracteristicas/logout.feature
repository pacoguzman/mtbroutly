Característica: Log out
  Para proteger mi cuenta de accesos no autorizados
  Como usuario logueado
  Quiero ser capaz de terminar la sesión
  
    Escenario: El usuario inicia sesión y luego cierra la sesión
	  Dado que he iniciado sesión como "login/password"
      Cuando visito la home
        Y pulso el enlace "Log-out"
      Entonces debo ver el texto "You are now signed out"
	    Y no debo estar logueado
      
	Escenario: El usuario inicia sesión con recuerda me  y luego cierra sesión
      Dado que he iniciado sesión pulsando "recuerda me" como "login/password"
      Cuando visito la home
	    Y pulso el enlace "Log-out"
      Entonces debo ver el texto "You are now signed out"
        Y no debo estar logueado