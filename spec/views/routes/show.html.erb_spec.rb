require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/routes/show.html.erb" do
  include RoutesHelper
  before(:each) do
    assigns[:route] = @route = stub_model(Route,
      :title => "value for title",
      :description => "value for description",
      :user_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
  end
end

