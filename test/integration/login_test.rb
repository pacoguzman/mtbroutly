require File.dirname(__FILE__) + '/../test_helper'

class LoginTest < ActionController::IntegrationTest

  context "for existing user activated" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
    end

    should "logging with valid username and password" do
      visit login_path
      fill_in "Login", :with => @user.login
      fill_in "Password", :with => @user.password
      click_button "Sign In"
      assert_contain "Logged in successfully"
    end

    should "not logging with invalid password" do
      visit login_path
      fill_in "Login", :with => @user.login
      fill_in "Password", :with => "badsecret"
      click_button "Sign In"
      assert_contain "Incorrect username or password."
      assert_nil session[:user_id]
    end

    should "not logging with invalid username" do
      visit login_path
      fill_in "Login", :with => "badlogin"
      fill_in "Password", :with => @user.password
      click_button "Sign In"
      assert_contain "Incorrect username or password."
      assert_nil session[:user_id]
    end
  end
  
end
