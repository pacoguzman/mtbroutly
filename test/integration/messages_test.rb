require File.dirname(__FILE__) + '/../test_helper'

class MessagesTest <

  context "An activated user logged in" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      basic_auth(@user.login, @user.password)
    end

    should "be able to view his messages list" do
      visit root_path
      click_link "My Messages"
      assert_contain "Mail"
    end

    should "be able to create a new message" do
      visit root_path
      click_link "My Messages"
      click_link "Create new message"
      assert_contain "Compose a new message"
      #TODO completar la creación de mensajes
      #fill_in "To", :with => ""
      #fill_in "Subject", :with => "New developer member"
      #fill_in "Content", :with => "Ryan Bates is a new member of the developers group"
    end
  end

end
