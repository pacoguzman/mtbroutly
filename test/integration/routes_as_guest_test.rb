require File.dirname(__FILE__) + '/../test_helper'

class RoutesAsGuestTest < ActionController::IntegrationTest
  
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

    end

    should "be able to visit the routes path" do
      visit root_path
      click_link "Rutas" #FIXME modificar el locale
      assert_contain "Routes" #TODO titulo del listado de rutas
    end

    should "be able to search with one-click newest routes" do
      visit root_path
      click_link "Rutas"
      click_link "Newest Routes"
      assert_contain "New Routes"
    end

    should "be able to search with one-click highlighted routes" do
      visit root_path
      click_link "Rutas"
      click_link "Highlighted Routes"
      assert_contain "Highlighted Routes"
    end

  end
end
