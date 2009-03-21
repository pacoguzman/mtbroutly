require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/waypoints/index.html.erb" do
  include WaypointsHelper
  
  before(:each) do
    assigns[:waypoints] = [
      stub_model(Waypoint,
        :address => "value for address",
        :lat => 9.99,
        :lng => 9.99,
        :alt => 9.99,
        :locatable_id => 1,
        :locatable_type => "value for locatable_type",
        :position => 1
      ),
      stub_model(Waypoint,
        :address => "value for address",
        :lat => 9.99,
        :lng => 9.99,
        :alt => 9.99,
        :locatable_id => 1,
        :locatable_type => "value for locatable_type",
        :position => 1
      )
    ]
  end

  it "renders a list of waypoints" do
    render
    response.should have_tag("tr>td", "value for address".to_s, 2)
    response.should have_tag("tr>td", 9.99.to_s, 2)
    response.should have_tag("tr>td", 9.99.to_s, 2)
    response.should have_tag("tr>td", 9.99.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for locatable_type".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

