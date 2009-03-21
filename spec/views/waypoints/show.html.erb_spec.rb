require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/waypoints/show.html.erb" do
  include WaypointsHelper
  before(:each) do
    assigns[:waypoint] = @waypoint = stub_model(Waypoint,
      :address => "value for address",
      :lat => 9.99,
      :lng => 9.99,
      :alt => 9.99,
      :locatable_id => 1,
      :locatable_type => "value for locatable_type",
      :position => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ address/)
    response.should have_text(/9\.99/)
    response.should have_text(/9\.99/)
    response.should have_text(/9\.99/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ locatable_type/)
    response.should have_text(/1/)
  end
end

