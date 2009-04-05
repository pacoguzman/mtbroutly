Característica: Vistando la portada
  Para ver todo lo que puedo hacer en esta estupenda aplicación
  Como [sujeto]
  Quiero visitar la página principal

  Escenario: Usuario no logueado visitando la home
	Dado que existe un conjunto de usuarios
	  Y que existe un conjunto de grupos
	  Y que existe un conjunto de rutas
	Cuando visito la home
	Entonces debo ver el texto "Featured Users"
	  Y debo ver el texto "Routes"
	  Y debo ver el texto "Groups"
	  Y debo ver el conjunto de usuarios
	  Y debo ver el conjunto de grupos
	  Y debo ver el conjunto de rutas

  Escenario: Usuario logueado visitando la home
    Dado que existe un usuario logueado
    Dado que existe un conjunto de usuarios
	  Y que existe un conjunto de grupos
	  Y que existe un conjunto de rutas
    Cuando visito la home
    Entonces debo ver el texto "Featured Users"
	  Y debo ver el texto "Routes"
	  Y debo ver el texto "Groups"
	  Y debo ver el conjunto de usuarios
	  Y debo ver el conjunto de grupos
	  Y debo ver el conjunto de rutas
	  Y debo ver un mensaje de bienvenida
	  Y debo ver un footer con mis links

  Escenario: Usuario logueado visitando la portada y que sigue el enlace log-out
    Dado que he iniciado sesión como "login/password"
    Cuando visito la home
    Entonces pulso el enlace "Log-out"
	 Y debo haber terminado la sesión

  Escenario: Usuario no logueado visitando la portada y que sigue el enlace log-in e inicia sesion
    Cuando visito la home
	  Y pulso el enlace "Log-in"
    Entonces debo estar en la home


  Escenario: Usuario no registrado visitando la portada y que sigue el enlace sign-up y se registra
    Cuando visito la home
	  Y pulso el enlace "Sign up"
    Entonces debo estar en la homer
	