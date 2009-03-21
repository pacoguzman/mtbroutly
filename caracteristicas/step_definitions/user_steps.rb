# Database

Dado /^que no existe un usuario registrado como "(.*)"$/ do |login|
  assert_nil User.find_by_login(login)
end

Dado /^que existe un usuario registrado como "(.*)\/(.*)\/(.*)"$/ do |login, email, password|
  Dado %{que tenemos el usuario:
          | login | password | password_confirmation | email |
          | #{login} | #{password} | #{password} | #{email}
  }
end

Dado /^que existe un usuario registrado y activado como "(.*)\/(.*)"$/ do |login, password|
  Dado %{que tenemos el usuario:
          | login | password | password_confirmation | email |
          | #{login} | #{password} | #{password} | #{login}@#{login}.com |
       }
  last_mentioned.activate!
end

Dado /^que activamos dicho usuario$/ do
  last_mentioned.activate!
end

#Actions

Cuando /^sigo el link de activación enviado a "(.*)"$/ do |login|
  user = User.find_by_login(login)
  visit "/activate/#{user.activation_code}"
end