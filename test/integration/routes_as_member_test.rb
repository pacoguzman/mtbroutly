require File.dirname(__FILE__) + '/../test_helper'

class RoutesAsMemberTest < ActionController::IntegrationTest

  context "existing some data" do
    setup do
      @user = User.create!(:login => "rbates", :email => "ryan@example.com", :password => "secret", :password_confirmation => "secret")
      @user.activate!

      @route = Factory.build(:route, :title => "Ruta Maya", :user_id => @user.id)
      @route.waypoints << Factory.build(:waypoint, :position => 1)
      @route.waypoints << Factory.build(:near_waypoint, :position => 2)
      @route.save!

      @other_route = Factory.build(:route, :title => "Ruta Azteca", :user_id => @user.id)
      @other_route.waypoints << Factory.build(:waypoint, :position => 1)
      @other_route.waypoints << Factory.build(:near_waypoint, :position => 2)
      @other_route.save!

      @member = User.create!(:login => "obeyf", :email => "obey@example.com", :password => "secret", :password_confirmation => "secret")
      @member.activate!
      basic_auth(@member.login, @member.password)
    end

    should "be able to visit the routes path" do
      visit root_path
      click_link "Rutas" #FIXME modificar el locale
      assert_contain I18n.t("interface.routes.titles.default")
    end

    should "be able to search with one-click newest routes" do
      visit root_path
      click_link "Rutas"
      click_link "Newest Routes"
      assert_contain I18n.t("interface.routes.titles.newest")
    end

    should "be able to search with one-click highlighted routes" do
      visit root_path
      click_link "Rutas"
      click_link "Highlighted Routes"
      assert_contain I18n.t("interface.routes.titles.highlighted")
    end

    should "be able to search with one-click routes close to you" do
      visit root_path
      click_link "Rutas"
      #TODO
      #click_link "Highlighted Routes"
      #assert_contain I18n.t("interface.routes.titles.highlighted")
    end

    should "be able to search with one-click routes created by you" do
      visit root_path
      click_link "Rutas"
      click_link "Created by you"
      assert_contain I18n.t("interface.routes.titles.created_by_you")
    end

    should "be able to search with one-click your favorites routes" do
      visit root_path
      click_link "Rutas"
      #TODO
      #click_link "Your favorites routes"
      #assert_contain I18n.t("interface.routes.titles.your_favorites")
    end
  end
end
