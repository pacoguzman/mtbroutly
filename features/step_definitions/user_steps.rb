Given /^an registered user exists as "(.*)\/(.*)\/(.*)"$/ do |login, email, password|
  user = Factory.create(:user, :login => login, :email => email, :password => password, :password_confirmation => password)
  #user.register!
  #user.activate!
end