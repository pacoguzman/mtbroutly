When /^I want to remember my password$/ do
  visit root_path
  click_link "Log-in"
  click_link "email it to you"
end