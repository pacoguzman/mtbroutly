Caracteristica: Gestión de grupos
  Para que los usuarios esten contentos y puedan gestionar grupos
  Como miembro de la aplicación
  Quiero poder realizar operaciones sobre grupos

  Escenario: Creación de un nuevo grupo
    Dado que he iniciado sesión como "login/password"
      Y que visito la portada
      Y que pulso el enlace "Create a new Group"
    Entonces debo ver el texto "Create group"
    Cuando relleno "nombre" con "Developers"
      Y relleno "descripcion" con "Grupo de desarrolladores de la aplicación"
      Y relleno "lista_de_tags" con "developers,dev,init"
      Y pulso el botón "Create"
    Entonces debo ver el texto "Group created succesfully"
      Y veo el texto "Developers"
      Y veo el texto "Grupo de desarrolladores de la aplicación"

  Escenario: Editar los datos de un grupo ya completado