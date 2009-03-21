require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/routes/edit.html.erb" do
  include RoutesHelper
  
  before(:each) do
    assigns[:route] = @route = stub_model(Route,
      :new_record? => false,
      :title => "value for title",
      :description => "value for description",
      :user_id => 1
    )
  end

  it "renders the edit route form" do
    render
    
    response.should have_tag("form[action=#{route_path(@route)}][method=post]") do
      with_tag('input#route_title[name=?]', "route[title]")
      with_tag('textarea#route_description[name=?]', "route[description]")
      with_tag('input#route_user_id[name=?]', "route[user_id]")
    end
  end
end


