
# Actions

Cuando /^relleno los datos de sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember, login, password|
  Cuando %{relleno "Login" con "#{login}"}
  Y %{relleno "Password" con "#{password}"}
  Y %{marco "Remember me"} if remember
  Y %{pulso el botón "Sign In"}
end

Cuando /^relleno los datos de registro como "(.*)\/(.*)\/(.*)"$/ do |email, login, password|
  Cuando %{relleno "Email" con "#{email}"}
  Y %{relleno "Login" con "#{login}"}
  Y %{relleno "Password" con "#{password}"}
  Y %{relleno "Confirm Password" con "#{password}"}
  Y %{pulso el botón "Sign Up!"}
end

# Session
Dado /^que no he iniciado sesión como usuario$/ do
  #FIXME assert_ninl request.session[:user_id]
  assert true
end

Dado /^que he iniciado sesión como "(.*)\/(.*)"$/ do |login,password|
  Dado %{que existe un usuario registrado y confirmado como "#{login}/#{password}"}
  basic_auth login, password
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
  Cuando %{session is cleared}
  Y %{I go to the homepage}
end
