#FIXME dependerá del elemento de login que se utilice
Given /^no user exists as "(.*)"$/ do |login|
  assert_nil User.find_by_login(login)
end