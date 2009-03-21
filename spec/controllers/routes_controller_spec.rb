require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module DefaultPaginationParams
  def pagination_params(options = {})
    options.reverse_merge :per_page => '10', :page => '1', :order => 'updated_at desc'
  end
end


describe RoutesController do
  include DefaultPaginationParams

  def mock_route(stubs={})
    @mock_route ||= mock_model(Route, stubs)
  end
  
  describe "GET index" do

    before(:each) do
      Route.should_receive(:paginate).with( pagination_params(:include => :waypoints, :conditions => {})).and_return([mock_route])
      get :index
    end

    it "exposes all routes as @routes" do
      assigns[:routes].should == [mock_route]
    end

    it "Should assign list title"
    it "Should assign paginations params"
    it "Should assign page title"
    it "Should assign metadata tags"

    it { should respond_with(:success) }
    it { should_not set_the_flash }
  end

  describe "GET newest" do
    it "exposes the newests as @routes"
  end

  describe "GET highlighted" do
    it "exposes highlighted routes as @routes"
  end

  describe "GET index with mime type of xml" do
    before(:each) do
      Route.should_receive(:paginate).with( pagination_params(:include => :waypoints, :conditions => {})).and_return(routes = mock("Array of Routes"))
      routes.should_receive(:to_xml).and_return("generated XML")
      get :index, :format => 'xml'
    end
    
    it "renders all routes as xml" do
      response.body.should == "generated XML"
    end

    it { should respond_with(:success) }
  end

  describe "GET show with valid id" do
    before(:each) do
      Route.should_receive(:find).with("37", :include => :waypoints).and_return(mock_route)
      get :show, :id => "37"
    end

    it "exposes the requested route as @route" do
      assigns[:route].should equal(mock_route)
    end

    it { should respond_with(:success) }
    it { should_not set_the_flash }
  end

  describe "GET show with valid id and with mime type of xml" do
    before(:each) do
      Route.should_receive(:find).with("37", :include => :waypoints).and_return(mock_route)
      mock_route.should_receive(:to_xml).and_return("generated XML")
      get :show, :id => "37", :format => 'xml'
    end

    it "renders the requested route as xml" do
      response.body.should == "generated XML"
    end

    it { should respond_with(:success) }
  end

  describe "GET show with invalid id" do
    before(:each) do
      Route.should_receive(:find).with(any_args()).and_return(raise_error(ActiveRecord::RecordNotFound))
      get :show, :id => "1"
    end

    it { should assign_to :route } # Se asigna la excepción
    it { should_not set_the_flash }
    #FIXME it { should render_template "member/site/not_found"}
    it "should render_template member/site/not_found puede ser culpa de rspec"
    it "should respond_with a not_found error"
    it { should respond_with(:success) }
  end

  describe "authenticated actions" do
    it_should_behave_like "an authenticated controller"

    describe "GET created_by_you routes" do
      it "exposes created_by_you routes as @routes"
    end

    describe "GET close_to_you routes through your profile waypoint" do
      it "exposes close_to_you routes as @routes"
    end

    describe "GET close_to_you routes with waypoint param" do
      it "exposes created_to_you routes as @routes"
    end

   describe "GET your_favorites routes" do
      it "exposes your_favorites routes as @routes"
    end

    describe "POST rate to a route" do
      it "exposes the rated route as @route"
    end
  end

end
