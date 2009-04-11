require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActionController::IntegrationTest

  context "An activated user logged in" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      basic_auth(@user.login, @user.password)
    end

    should "be able to complete the profile" do
      visit root_path
      click_link "Edit Profile"
      assert_contain "Update Profile"
      fill_in "First name", :with => "Ryan"
      fill_in "Last name", :with => "Bates"
      fill_in "Website", :with => "http://railscasts.com"
      click_button "Update profile"
      assert_contain "Your profile was succcessfully updated!"
      assert_contain "Ryan"
      assert_contain "Bates"
      assert_contain "http://railscasts.com"
    end
  end

  context "A guest user" do
    setup do
      @user = User.create!(:login => "obey", :email => "obey@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      #FIXME with some factory
      @user.profile.update_attributes!(:first_name => "Obey", :last_name => "Fernandez", :website => "http://hashrocket.com")
      @profile = @user.profile
    end

    should "be able to view the list of profiles" do
      #FIXME not link to access
      visit root_path
      click_link "People"
      #visit profiles_path
      assert_contain "#{@profile.first_name} #{@profile.last_name}"
    end

    should "be able to view a specific profile" do
      visit root_path
      click_link "People"
      click_link "#{@profile.first_name} #{@profile.last_name}"
      assert_contain "#{@profile.first_name} #{@profile.last_name}"
    end
  end

end
