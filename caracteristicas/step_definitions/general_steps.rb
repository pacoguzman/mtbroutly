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

Cuando /^(?:que )?como (miembro|administrador) visito la p[áa]gina de ([\w\/]+) de (.+)$/i do |role, accion, modelo|
  model = modelo.to_unquoted.to_model or raise(MundoPepino::ModelNotMapped.new(modelo))
  action = accion.to_crud_action or raise(MundoPepino::CrudActionNotMapped.new(accion))
  #FIXME crear un mapeo de roles en mundo pepino
  role = "member" if role == "miembro"
  role = "admin" if role == "administrador"
  pile_up model.new
  do_visit eval("#{action}_#{role}_#{model.name.downcase}_path(:id => session[:user_id])")
end