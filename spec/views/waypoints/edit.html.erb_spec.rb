require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/waypoints/edit.html.erb" do
  include WaypointsHelper
  
  before(:each) do
    assigns[:waypoint] = @waypoint = stub_model(Waypoint,
      :new_record? => false,
      :address => "value for address",
      :lat => 9.99,
      :lng => 9.99,
      :alt => 9.99,
      :locatable_id => 1,
      :locatable_type => "value for locatable_type",
      :position => 1
    )
  end

  it "renders the edit waypoint form" do
    render
    
    response.should have_tag("form[action=#{waypoint_path(@waypoint)}][method=post]") do
      with_tag('input#waypoint_address[name=?]', "waypoint[address]")
      with_tag('input#waypoint_lat[name=?]', "waypoint[lat]")
      with_tag('input#waypoint_lng[name=?]', "waypoint[lng]")
      with_tag('input#waypoint_alt[name=?]', "waypoint[alt]")
      with_tag('input#waypoint_locatable_id[name=?]', "waypoint[locatable_id]")
      with_tag('input#waypoint_locatable_type[name=?]', "waypoint[locatable_type]")
      with_tag('input#waypoint_position[name=?]', "waypoint[position]")
    end
  end
end


