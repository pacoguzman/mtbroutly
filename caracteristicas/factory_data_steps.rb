Dado /^que existe un conjunto inicial de rutas$/ do
  Dado %{que existe un usuario registrado y confirmado como "jaimito/jaimitosjokes"}
  Dado %{que dicho usuario tiene la ruta
            | nombre | descripcion |
            | ruta_maya | descripcion_ruta_maya |
  }
  Dado %{que la ruta tiene los siguientes waypoints
            | latitud | longitud |
            | 40.790000 | -3.710000 |
            | 40.790020 | -3.710200 |
  }

  Dado %{que existe un usuario registrado y confirmado como "luisito/luisitomaravilla"}
  Dado %{que dicho usuario tiene la ruta
            | nombre | descripcion |
            | ruta_maravilla | descripcion_ruta_maravilla |
  }
  Dado %{que la ruta tiene los siguientes waypoints
            | latitud | longitud |
            | 40.840000 | -3.710000 |
            | 40.840020 | -3.710200 |
  }
end