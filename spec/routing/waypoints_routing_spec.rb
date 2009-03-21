require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WaypointsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "waypoints", :action => "index").should == "/waypoints"
    end
  
    it "maps #new" do
      route_for(:controller => "waypoints", :action => "new").should == "/waypoints/new"
    end
  
    it "maps #show" do
      route_for(:controller => "waypoints", :action => "show", :id => "1").should == "/waypoints/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "waypoints", :action => "edit", :id => "1").should == "/waypoints/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "waypoints", :action => "create").should == {:path => "/waypoints", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "waypoints", :action => "update", :id => "1").should == {:path =>"/waypoints/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "waypoints", :action => "destroy", :id => "1").should == {:path =>"/waypoints/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/waypoints").should == {:controller => "waypoints", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/waypoints/new").should == {:controller => "waypoints", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/waypoints").should == {:controller => "waypoints", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/waypoints/1").should == {:controller => "waypoints", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/waypoints/1/edit").should == {:controller => "waypoints", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/waypoints/1").should == {:controller => "waypoints", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/waypoints/1").should == {:controller => "waypoints", :action => "destroy", :id => "1"}
    end
  end
end
