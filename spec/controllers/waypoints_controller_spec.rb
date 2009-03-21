require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WaypointsController do

  def mock_waypoint(stubs={})
    @mock_waypoint ||= mock_model(Waypoint, stubs)
  end
  
  describe "GET index" do

    it "exposes all waypoints as @waypoints" do
      Waypoint.should_receive(:find).with(:all).and_return([mock_waypoint])
      get :index
      assigns[:waypoints].should == [mock_waypoint]
    end

    describe "with mime type of xml" do
  
      it "renders all waypoints as xml" do
        Waypoint.should_receive(:find).with(:all).and_return(waypoints = mock("Array of Waypoints"))
        waypoints.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested waypoint as @waypoint" do
      Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
      get :show, :id => "37"
      assigns[:waypoint].should equal(mock_waypoint)
    end
    
    describe "with mime type of xml" do

      it "renders the requested waypoint as xml" do
        Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
        mock_waypoint.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new waypoint as @waypoint" do
      Waypoint.should_receive(:new).and_return(mock_waypoint)
      get :new
      assigns[:waypoint].should equal(mock_waypoint)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested waypoint as @waypoint" do
      Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
      get :edit, :id => "37"
      assigns[:waypoint].should equal(mock_waypoint)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created waypoint as @waypoint" do
        Waypoint.should_receive(:new).with({'these' => 'params'}).and_return(mock_waypoint(:save => true))
        post :create, :waypoint => {:these => 'params'}
        assigns(:waypoint).should equal(mock_waypoint)
      end

      it "redirects to the created waypoint" do
        Waypoint.stub!(:new).and_return(mock_waypoint(:save => true))
        post :create, :waypoint => {}
        response.should redirect_to(waypoint_url(mock_waypoint))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved waypoint as @waypoint" do
        Waypoint.stub!(:new).with({'these' => 'params'}).and_return(mock_waypoint(:save => false))
        post :create, :waypoint => {:these => 'params'}
        assigns(:waypoint).should equal(mock_waypoint)
      end

      it "re-renders the 'new' template" do
        Waypoint.stub!(:new).and_return(mock_waypoint(:save => false))
        post :create, :waypoint => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested waypoint" do
        Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
        mock_waypoint.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :waypoint => {:these => 'params'}
      end

      it "exposes the requested waypoint as @waypoint" do
        Waypoint.stub!(:find).and_return(mock_waypoint(:update_attributes => true))
        put :update, :id => "1"
        assigns(:waypoint).should equal(mock_waypoint)
      end

      it "redirects to the waypoint" do
        Waypoint.stub!(:find).and_return(mock_waypoint(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(waypoint_url(mock_waypoint))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested waypoint" do
        Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
        mock_waypoint.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :waypoint => {:these => 'params'}
      end

      it "exposes the waypoint as @waypoint" do
        Waypoint.stub!(:find).and_return(mock_waypoint(:update_attributes => false))
        put :update, :id => "1"
        assigns(:waypoint).should equal(mock_waypoint)
      end

      it "re-renders the 'edit' template" do
        Waypoint.stub!(:find).and_return(mock_waypoint(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested waypoint" do
      Waypoint.should_receive(:find).with("37").and_return(mock_waypoint)
      mock_waypoint.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the waypoints list" do
      Waypoint.stub!(:find).and_return(mock_waypoint(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(waypoints_url)
    end

  end

end
