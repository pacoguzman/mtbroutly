When /^I fill the form of signup as "(.*)\/(.*)\/(.*)\/(.*)"$/ do |email,login,password,conf_password|
  When %{I fill in "user[email]" with "#{email}"}
  And %{I fill in "user[login]" with "#{login}"}
  And %{I fill in "user[password]" with "#{password}"}
  And %{I fill in "user[password_confirmation]" with "#{conf_password}"}
  And %{I press "Sign Up!"}
end
