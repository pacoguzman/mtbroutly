require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/routes/index.html.erb" do
  include RoutesHelper
  
  before(:each) do
    assigns[:routes] = [
      stub_model(Route,
        :title => "value for title",
        :description => "value for description",
        :user_id => 1
      ),
      stub_model(Route,
        :title => "value for title",
        :description => "value for description",
        :user_id => 1
      )
    ]
  end

  it "renders a list of routes" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

