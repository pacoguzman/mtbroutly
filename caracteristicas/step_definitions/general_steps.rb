# General

Entonces /^Veo mensajes de error$/ do
  Entonces %{Veo "error(s)? prohibited"}
end

negative_lookahead = '(?:la|el) \w+ de |su p[aá]gina|su portada'
Entonces /^debo estar en (?!#{negative_lookahead})(.+)$/i do |pagina|
  request.path.should  == pagina.to_unquoted.to_url
end

Entonces /^debo estar en el listado de rutas de ['"](.+)["']$/i do |nombre|
  if resource = last_mentioned_of("Usuario".to_unquoted, nombre)
    request.path.should == "/users/#{resource.to_param}/routes"
  end
end