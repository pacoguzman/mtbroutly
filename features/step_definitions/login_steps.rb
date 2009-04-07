When /^I fill the login form with "(.*)\/(.*)"$/ do |login,password|
  When %{I fill in "login" with "#{login}"}
  And %{I fill in "password" with "#{password}"}
  And %{I press "Sign In"}
end
