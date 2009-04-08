require 'test_helper'

class LoginTest < ActionController::IntegrationTest

  test "logging in with valid username and password" do
    user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
    user.activate!
    visit login_path
    fill_in "Login", :with => "rbates"
    fill_in "Password", :with => "secret"
    click_button "Sign In"
    assert_contain "Logged in successfully"
  end
  
  test "logging in with invalid username and password" do
    user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
    user.activate!
    visit login_path
    fill_in "Login", :with => "rbates"
    fill_in "Password", :with => "badsecret"
    click_button "Sign In"
    assert_contain "Incorrect username or password."
  end
end
