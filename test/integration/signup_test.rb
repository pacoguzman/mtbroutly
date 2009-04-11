require File.dirname(__FILE__) + '/../test_helper'


class SignupTest < ActionController::IntegrationTest

  should "signing up correctly with valid data" do
    visit signup_path
    fill_in "Login", :with => "rbates"
    fill_in "Email", :with => "rbates@example.com"
    fill_in "Password", :with => "secret"
    fill_in "Repeat password", :with => "secret"
    click_button "Sign up!"
    assert_contain "Thanks for signing up"
    assert_nil session[:user_id]
    #TODO debe haber enviado un correo electrónico de confirmación
    #TODO debo estar en la home
  end

  should "not signing up with invalid data" do
    visit signup_path
    fill_in "Login", :with => "rbates"
    fill_in "Email", :with => "rbates@example.com"
    fill_in "Password", :with => "secret"
    fill_in "Repeat password", :with => "badsecret"
    click_button "Sign up!"
    assert_contain "error prohibited"
    assert_nil session[:user_id]
    #TODO debo estar en la página de registro
  end

  should "activate account from confimation email link" do
    user = User.create!(:login => "rbates", :email => "rbates@example.com", :password => "secret", :password_confirmation => "secret")
    visit activate_path(user.activation_code)
    puts "#{response_body}"
    assert_contain "Signup complete!"
    #TODO no debo estar logueado
    #TODO debo estar en la home
  end

end
