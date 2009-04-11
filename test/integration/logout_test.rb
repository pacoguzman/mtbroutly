require File.dirname(__FILE__) + '/../test_helper'

class LogoutTest < ActionController::IntegrationTest
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  context "An existing user logged in" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
    end

    should "logout correctly after clicking logout link" do
      basic_auth(@user.login, @user.password)
      visit root_path
      click_link "Log-out"
      assert_contain "You are now signed out"
      assert_nil session[:user_id]
    end

    should "logout correctly after clicking logout link with remember me checked" do
      post "/session", :login => @user.login, :password => @user.password, :remember_me => "1"
      visit root_path
      click_link "Log-out"
      assert_contain "You are now signed out"
      assert_nil session[:user_id]
    end
  end
end
