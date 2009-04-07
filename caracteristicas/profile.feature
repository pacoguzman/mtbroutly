Caracteristica: Gestión del perfil del usuario
  Para que los usuarios esten contentos
  Como miembro de la aplciación
  Quiero poder realizar operaciones sobre mi perfil

  Escenario: Completar los datos del perfil
    Dado que he iniciado sesión como "login/password"
      Y que como miembro visito la página de edición de perfil
    Cuando relleno "nombre" con "Paco"
      Y relleno "apellido" con "Guzmán"
      Y relleno "web" con "http://www.ridingtonowhere.com"
      Y pulso el botón "Update profile"
    Entonces debo ver el texto "Paco"
      Y veo el texto "Guzmán"
      Y veo el texto "http://www.ridingtonowhere.com"

  Escenario: Editar los datos de un perfil ya completado