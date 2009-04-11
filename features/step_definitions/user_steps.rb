Given /^an registered user exists as "(.*)\/(.*)\/(.*)"$/ do |login, email, password|
  user = Factory :user,
    :login => login, :email => email, :password => password, :password_confirmation => password
end