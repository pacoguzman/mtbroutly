require File.dirname(__FILE__) + '/../test_helper'

class GroupsTest < ActionController::IntegrationTest

  context "A guest user" do
    should "be able to vist the groups list from root_path" do
      visit root_path
      click_link "Groups"
      assert_contain "Groups"
      assert_contain "Last groups"
    end

    should "not be able to create a group" do
      visit groups_path
      click_link "Create new group"
      #TODO será redirigido por el login required
      #new_session_path
      assert_equal new_session_path, path
    end
  end

  context "A logged in user" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      basic_auth(@user.login, @user.password)
    end

    should "be able to create a group with valid data" do
      visit groups_path
      click_link "Create new group"
      fill_in "Name", :with => "Developers"
      fill_in "Description", :with => "Group created for the developers of the application"
      fill_in "Tags", :with => "developers, devs, awesome"
      click_button "Create"
      group = @user.groups.first
      assert_equal group_path(group), path
      assert_contain group.name
      assert_contain group.description
    end

    should "not create a group with invalid data" do
      visit groups_path
      click_link "Create new group"
      fill_in "Name", :with => ""
      fill_in "Description", :with => "Group created for the developers of the application"
      click_button "Create"
      
      assert_template 'new'
      assert_contain /error prohibited/
      assert @user.groups.empty?
    end

  end

  context "A logged in user author of a group" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      @group = Group.create!(:author => @user, :name => "railscasters", :description => "Group of the author of the screencasts from railscasts")
      @group.join(@user, true)
      @group.activate_membership(@user)
      @group.activate!
      basic_auth(@user.login, @user.password)
    end

    should "be able to update a group moderated by him" do
      visit root_path
      click_link "My Groups"
      assert_contain @group.name
      click_link "Edit Group"
      assert_contain @group.name
      assert_contain @group.description
      fill_in "Name", :with => "Railscasters"
      fill_in "Description", :with => "Group of the author of the screencasts from railscasts.com"
      fill_in "Tags", :with => "railscats, screencasts"
      click_button "Update"

      assert_contain "Railscasters"
      assert_contain "Group of the author of the screencasts from railscasts.com"
      assert_contain "succcessfully updated!"
      assert group_path(@group), path
    end
  end

  context "A logged in user member of a other user group" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!
      @group = Group.create!(:author => @user, :name => "railscasters", :description => "Group of the author of the screencasts from railscasts")
      @group.join(@user, true)
      @group.activate_membership(@user)
      @group.activate!

      @other_user = User.create!(:login => "obey", :email => "obey@example.com", :password => "secret", :password_confirmation => "secret")
      @other_user.activate!
      
      basic_auth(@other_user.login, @other_user.password)
    end

    should "be able to join that group" do
      visit root_path
      click_link "Groups"
      click_link @group.name
      click_link "Join this group"
      assert_cointain "Welcome to the group"
      assert group_path(@group), path
      assert_cointain "You are a member of this group."
    end

    # with-selenium
    should "be able to leave that group" do
      @group.join(@other_user, true)
      @group.activate_membership(@user)

      visit root_path
      click_link "Groups"
      click_link @group.name
      
    end
  end
  
end
