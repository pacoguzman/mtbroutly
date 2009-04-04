
# Actions

Cuando /^relleno los datos de sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember, login, password|
  When %{relleno "Login" con "#{login}"}
  And %{relleno "Password" con "#{password}"}
  And %{marco "Remember me"} if remember
  And %{pulso el botón "Sign In"}
end

Cuando /^relleno los datos de registro como "(.*)\/(.*)\/(.*)"$/ do |email, login, password|
  When %{relleno "Login" con "#{login}"}
  And %{relleno "Email" con "#{email}"}
  And %{relleno "Password" con "#{password}"}
  And %{relleno "Confirm Password" con "#{password}"}
  And %{pulso el botón "Sign Up!"}
end

# Session
Dado /^que no he iniciado sesión como usuario$/ do
  #FIXME assert_ninl request.session[:user_id]
  assert true
end

Dado /^que he iniciado sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember,login,password|
  Given %{que existe un usuario registrado y activado como "#{login}/#{login}@#{login}.com/#{password}"}
  When %{relleno los datos de sesión pulsando recuerda me como "#{login}/#{password}"} if remember
  basic_auth login, password unless remember
end

Entonces /^debo estar logueado$/ do
  assert_not_nil request.session[:user_id]
end

Entonces /^no debo estar logueado$/ do
  assert_nil request.session[:user_id]
end

Entonces /^debo haber terminado la sesión$/ do
  pending
end

Cuando /^regreso la próxima vez$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end
