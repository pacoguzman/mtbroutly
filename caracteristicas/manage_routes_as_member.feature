Característica: Gestión de Rutas como usuario
  Para [Beneficio]
  Como member (iniciada sesión como usuario)
  Quiero [característica/comportamiento]
  
  Escenario: Visitar el listado general de mis rutas como member
    Dado que he iniciado sesión como "Luisito/luisito"
	  Y que tenemos un conjunto inicial de rutas del usuario "Luisito"
	  Y que tenemos una ruta de otro usuario
	  Y que dicha ruta es favorita del usuario "Luisito"
	Cuando visito el listado general de mis rutas como member
	Entonces debo ver el conjunto inicial de mis rutas como miembro
	  Y debo ver una ruta favorita de otro usuario como miembro
	
  Escenario: Crear una ruta válida como member
    Dado que he iniciado sesión como "Luisito/luisito"
	Cuando visito la creación de rutas como member
	  Y relleno "Title" con "Nueva Ruta"
	  Y relleno "Description" con "Descripción nueva ruta"
	  Y relleno "Waypoints" con "estructura json que describe los waypoints"
	  Y pulso el botón "Create"
	Entonces debo ser redirigido a el listado general de mis rutas como member
	  Y debo ver el texto "Succesfully created"
	  Y debe ser asignada al usuario "Luisito"
	  
  Escenario: Crear una ruta inválida como member # El resto de posibles casos a nivel de Modelo o Controlador
    Dado que he iniciado sesión como "Luisito/luisito"
	Cuando visito la creación de rutas como member
	  Y relleno "Title" con ""
	  Y relleno "Description" con "Descripción nueva ruta"
	  Y relleno "Waypoints" con "estructura json que describe los waypoints"
	  Y pulso el botón "Create"
	Entonces debo ser redirigido a la creación de rutas como member
	  Y debo ver el texto "Unsuccesfully created"
	  
  Escenario: Actualizar una ruta correctamente como member
    Dado que he iniciado sesión como "Luisito/luisito"
	  Y que dicho usuario tiene la siguiente ruta
	  | nombre | descripcion |
	  | ruta_completa | description ruta completa | 
	  Y que dicha ruta tiene los siguientes Waypoints
	  | latitud | longitud |
	  | 40.790000 | -3.090000 | 
	  | 40.790005 | -3.090005 |
	Cuando visito la edición de la ruta "ruta_completa" como member
	  Y relleno "Title" con "Ruta completada"
	  Y pulso el botón "Update"
	Entonces debo ser redirigido al listado de mis rutas como member
      Y debo ver el texto "Succesfully Updated"
      Y debo ver el texto "Ruta completada"
  
  Escenario: Actualizar una ruta incorrectamente como member
    Dado que he iniciado sesión como "Luisito/luisito"
	  Y que dicho usuario tiene la siguiente ruta
	  | nombre | descripcion |
	  | ruta_completa | description ruta completa | 
	  Y que dicha ruta tiene los siguientes Waypoints
	  | latitud | longitud |
	  | 40.790000 | -3.090000 | 
	  | 40.790005 | -3.090005 |
	Cuando visito la edición de la ruta "ruta_completa" como member
	  Y relleno "Title" con ""
	  Y pulso el botón "Update"
	Entonces debo ser redirigido al listado de mis rutas como member
      Y debo ver el texto "Succesfully Updated"
      Y debo ver el texto "Ruta completada"
  
  Escenario: Eliminar una ruta como member	
    Dado que he iniciado sesión como "Luisito/luisito"
      Y que dicho usuario tiene la siguiente ruta
      | nombre | descripcion |
	  | ruta_completa | description ruta completa | 
	  Y que dicha ruta tiene los siguientes Waypoints
	  | latitud | longitud |
	  | 40.790000 | -3.090000 | 
	  | 40.790005 | -3.090005 |
    Cuando visito la página de la ruta "ruta_completa" como member
	  Y pulso el enlace "Delete"
	Entonces debo ser redirigido al listado de mis rutas como member
	  Y debo ver el texto "Deleted"
	  Y no debo ver el texto "ruta_completa"
	  
  Escenario: Visitar el listado general de rutas creadas por ti
    Dado que he iniciado sesión como "Luisito/luisito"
      Y que tenemos un conjunto inicial de rutas del usuario "Luisito"
    Cuando visito el listado general de rutas
	  Y pulso el enlace "created by you"
    Entonces debo ver el conjunto inicial de rutas como listado general creadas por ti	
	  Y debo estar en el listado general de rutas creadas por ti
	  
  Escenario: Visitar el listado general de tus rutas favoritas
    Dado que he iniciado sesión como "Luisito/luisito"
      Y que tenemos un conjunto inicial de rutas del usuario "Luisito"
	  Y que tenemos una ruta de otro usuario
	  Y que dicha ruta es favorita del usuario "Luisito"
    Cuando visito el listado general de rutas
	  Y pulso el enlace "your favorites"
    Entonces debo ver el conjunto inicial de rutas como listado general de mis favoritas
	  Y debo estar en el listado general de rutas de mis favoritas  	
	  
  Escenario: Visitar el listado general de las rutas cercanas al home de tu perfil
    Dado que he iniciado sesión como "Luisito/luisito"
	  Y que dicho usuario tiene el siguiente Waypoint
	    | latitud | longitud |
      Y que tenemos un conjunto inicial de rutas alguna cercana al home del perfil
    Cuando visito el listado general de rutas
	  Y pulso el enlace "close to your home"
    Entonces debo ver el conjunto inicial de rutas como listado general de rutas cercanas
	  Y debo estar en el listado general de rutas rutas cercanas
	  
  Escenario: Visitar el listado general de las rutas cercanas a un waypoint como parámetro
    Dado que he iniciado sesión como "Luisito/luisito"
      Y que tenemos un conjunto inicial de rutas alguna cercana al waypoint parámetro
    Cuando visito el listado general de rutas
	  Y pulso el enlace "close to"
	  Y específico el waypoint
	  Y pulso el enlace "send"
    Entonces debo ver el conjunto inicial de rutas como listado general de rutas cercanas
	  Y debo estar en el listado general de rutas rutas cercanas	  