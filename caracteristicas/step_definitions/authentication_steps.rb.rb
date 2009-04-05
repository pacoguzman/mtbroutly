
# Actions
Cuando /^relleno los datos de sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember, login, password|
  Cuando %{relleno "login" con "#{login}"}
  Y %{relleno "password" con "#{password}"}
  Y %{marco "Remember me"} if remember
  Y %{pulso el botón "Sign In"}
end

Cuando /^relleno los datos de registro como "(.*)\/(.*)\/(.*)\/(.*)"$/ do |email, login, password, conf_password|
  Cuando %{relleno "login" con "#{login}"}
  Y %{relleno "email" con "#{email}"}
  Y %{relleno "password" con "#{password}"}
  #FIXME xq si le pones un texto lo pilla como preferente al label
  #And %{relleno "password_confirmation" con "#{password}"}
  Y %{relleno "user[password_confirmation]" con "#{conf_password}"}
  Y %{pulso el botón "Sign Up!"}
end

# Session
Dado /^que no he iniciado sesión como usuario$/ do
  #FIXME assert_ninl request.session[:user_id]
  assert true
end

Dado /^que he iniciado sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember,login,password|
  Dado %{que existe un usuario registrado y activado como "#{login}/#{login}@#{login}.com/#{password}"}
  post "/session", :login => last_mentioned.login, :password => password
  post "/session", :login => last_mentioned.login, :password => password, :remember_me => "1" if remember
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
  y %{I go to the homepage}
end

# Emails

Entonces /^debe enviarse un mensaje para la confirmación a la dirección "(.*)"$/ do |email|
  user = User.find_by_email(email)
  sent = ActionMailer::Base.deliveries.first
  assert_equal [user.email], sent.to
  assert_match /activate/i, sent.subject
  assert !user.activation_code.blank?
  assert_match /#{user.activation_code}/, sent.body
end

Cuando /^sigo el link de confirmación enviado a "(.*)"$/ do |login|
  user = User.find_by_login(login)
  visit activate_path(user.activation_code)
end
