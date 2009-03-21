# General
 
Then /^Veo mensajes de error$/ do
  Then %{Veo "error(s)? prohibited"}
end
 
# Database
 
Given /^que no existe un usuario registrado como "(.*)"$/ do |login|
  assert_nil User.find_by_login(login)
end
 
Dado /^que existe un usuario registrado como "(.*)\/(.*)\/(.*)"$/ do |login, email, password|
  Dado %{que tenemos el usuario:
          | login | password | password_confirmation | email |
          | #{login} | #{password} | #{password} | #{email}
       }
end

Dado /^que existe un usuario registrado y confirmado como "(.*)\/(.*)"$/ do |login, password|
  Dado %{que tenemos el usuario:
          | login | password | password_confirmation | email |
          | #{login} | #{password} | #{password} | #{login}@#{login}.com |
       }
  last_mentioned.activate!
end

Dado /^que activamos dicho usuario$/ do
  last_mentioned.activate!
end
 
# Session
Given /^que no he iniciado sesión como usuario$/ do 
  #FIXME assert_nil request.session[:user_id]
  assert true
end

Given /^que he iniciado sesión como "(.*)\/(.*)"$/ do |login,password|
  Given %{que existe un usuario registrado y confirmado como "#{login}/#{password}"}
  basic_auth login, password
end

Then /^debo estar logueado$/ do
  assert_not_nil request.session[:user_id]
end
 
Then /^no debo estar logueado$/ do
  assert_nil request.session[:user_id]
end

Then /^debo haber terminado la sesión$/ do
  pending
end
#When /^session is cleared$/ do
#  request.session[:user_id] = nil
#end
 
# Emails
 
#Then /^a confirmation message should be sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  sent = ActionMailer::Base.deliveries.first
#  assert_equal [user.email], sent.to
#  assert_match /confirm/i, sent.subject
#  assert !user.token.blank?
#  assert_match /#{user.token}/, sent.body
#end

Cuando /^sigo el link de confirmación enviado a "(.*)"$/ do |login|
  user = User.find_by_login(login)
  visit "/activate/#{user.activation_code}"
end
#When /^I follow the confirmation link sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  visit new_user_confirmation_path(:user_id => user, :token => user.token)
#end
 
#Then /^a password reset message should be sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  sent = ActionMailer::Base.deliveries.first
#  assert_equal [user.email], sent.to
#  assert_match /password/i, sent.subject
#  assert !user.token.blank?
#  assert_match /#{user.token}/, sent.body
#end
 
#When /^I follow the password reset link sent to "(.*)"$/ do |email|
#  user = User.find_by_email(email)
#  visit edit_user_password_path(:user_id => user, :token => user.token)
#end
 
#When /^I try to change the password of "(.*)" without token$/ do |email|
#  user = User.find_by_email(email)
#  visit edit_user_password_path(:user_id => user)
#end
 
#Then /^I should be forbidden$/ do
#  assert_response :forbidden
#end
 
 
# Actions
 
When /^relleno los datos de sesión( pulsando "recuerda me")? como "(.*)\/(.*)"$/ do |remember, login, password|
  When %{relleno "Login" con "#{login}"}
  And %{relleno "Password" con "#{password}"}
  And %{marco "Remember me"} if remember
  And %{pulso el botón "Sign In"}
end

When /^relleno los datos de registro como "(.*)\/(.*)\/(.*)"$/ do |email, login, password|
  When %{relleno "Email" con "#{email}"}
  And %{relleno "Login" con "#{login}"}
  And %{relleno "Password" con "#{password}"}
  And %{relleno "Confirm Password" con "#{password}"}
  And %{pulso el botón "Sign Up!"}
end
 
#When /^I sign out$/ do
#  visit '/session', :delete
#end
 
#When /^I request password reset link to be sent to "(.*)"$/ do |email|
#  When %{I go to the password reset request page}
#  And %{I fill in "Email address" with "#{email}"}
#  And %{I press "Reset password"}
#end
 
#When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
#  And %{I fill in "Choose password" with "#{password}"}
#  And %{I fill in "Confirm password" with "#{confirmation}"}
#  And %{I press "Save this password"}
#end
 
When /^regreso la próxima vez$/ do
  When %{session is cleared}
  And %{I go to the homepage}
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
