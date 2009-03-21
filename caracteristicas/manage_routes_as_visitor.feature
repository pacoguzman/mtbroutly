Característica: Gestión de Rutas
  Para [Beneficio]
  Como visitante
  Quiero [característica/comportamiento]
  
  Escenario: Visitar el listado general de rutas
	Dado que no he iniciado sesión como usuario
      Y que tenemos el usuario:
        | nombre | password | conf_password | correo |
        | jaimito | jaimitosjokes | jaimitosjokes | jaimito@jaimito.jokes |
      Y que activamos dicho usuario
	  Y que dicho usuario tiene la siguiente ruta:
            | nombre | descripcion |
            | ruta_maya | descripcion_ruta_maya |
      Y que dicha ruta tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.790000 | -3.710000 |
            | 40.790020 | -3.710200 |
	Cuando visito el listado general de rutas
	Entonces debo ver el texto "ruta_maya"
      Y debo ver el texto "descripcion_ruta_maya"
      Y debo estar en el listado general de rutas
	
  Escenario: Visitar el listado general de rutas más nuevas
    Dado que no he iniciado sesión como usuario
      Y que tenemos el usuario:
        | nombre | password | conf_password | correo |
        | jaimito | jaimitosjokes | jaimitosjokes | jaimito@jaimito.jokes |
      Y que activamos dicho usuario
	  Y que dicho usuario tiene las siguientes rutas:
            | nombre | descripcion |
            | ruta_maya | descripcion_ruta_maya |
            | ruta_azteca | descripcion_ruta_azteca |
      Y que la ruta "ruta_azteca" tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.790000 | -3.710000 |
            | 40.790020 | -3.710200 |
      Y que la ruta "ruta_maya" tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.7850000 | -3.710000 |
            | 40.785020 | -3.710200 |
    Cuando visito el listado general de rutas
	  Y pulso el enlace "newest routes"
    Entonces debo ver el texto "ruta_maya"
      Y debo ver el texto "ruta_azteca"
	  Y debo estar en el listado general de rutas más nuevas
      Y debo comprobar el orden de la rutas
	
  Escenario: Visitar el listado general de rutas mejor valoradas
    Dado que no he iniciado sesión como usuario
      Y que tenemos el usuario:
        | nombre | password | conf_password | correo |
        | jaimito | jaimitosjokes | jaimitosjokes | jaimito@jaimito.jokes |
      Y que activamos dicho usuario
	  Y que dicho usuario tiene las siguientes rutas:
            | nombre | descripcion |
            | ruta_maya | descripcion_ruta_maya |
            | ruta_azteca | descripcion_ruta_azteca |
      Y que la ruta "ruta_azteca" tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.790000 | -3.710000 |
            | 40.790020 | -3.710200 |
      Y que la ruta "ruta_maya" tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.7850000 | -3.710000 |
            | 40.785020 | -3.710200 |
    Cuando visito el listado general de rutas
	  Y pulso el enlace "highlighted routes"
   Entonces debo ver el texto "ruta_maya"
      Y debo ver el texto "ruta_azteca"
	  Y debo estar en el listado general de rutas mejor valoradas
      Y debo comprobar el orden de la rutas
	
  Escenario: Visitar el listado general de rutas de un usuario especificado
     Dado que no he iniciado sesión como usuario
	   Y que tenemos el usuario:
        | nombre | password | conf_password | correo |
        | jaimito | jaimitosjokes | jaimitosjokes | jaimito@jaimito.jokes |
      Y que activamos dicho usuario
	  Y que dicho usuario tiene la siguiente ruta:
            | nombre | descripcion |
            | ruta_maya | descripcion_ruta_maya |
      Y que dicha ruta tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.790000 | -3.710000 |
            | 40.790020 | -3.710200 |
      Y que tenemos el usuario:
        | nombre | password | conf_password | correo |
        | luisito | luisitomaravilla | luisitomaravilla | luisito@luisito.maravilla |
      Y que activamos dicho usuario
	  Y que dicho usuario tiene la siguiente ruta:
            | nombre | descripcion |
            | ruta_azteca | descripcion_ruta_azteca |
      Y que dicha ruta tiene los siguientes waypoints:
            | latitud | longitud |
            | 40.780000 | -3.720000 |
            | 40.780020 | -3.720200 |
	 Cuando visito el listado general de rutas
	   Y pulso el enlace "Jaimito"
     Entonces debo ver el texto "1 route"
     Cuando pulso el enlace "View All"
     Entonces debo ver el texto "descripcion_ruta_maya"
       Y debo estar en el listado de rutas de "jaimito"