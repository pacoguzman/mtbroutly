require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoutesController, "routes" do
  describe "route recognition with shoulda" do
    it { should route(:get, '/routes').to(:action => 'index') }
    it { should route(:get, '/routes/1').to(:action => 'show', :id => '1') }
    it { should route(:get, '/routes/newest').to(:action => 'newest') }
    it { should route(:get, '/routes/highlighted').to(:action => 'highlighted') }
    it { should route(:get, '/routes/search').to(:action => 'search') }
    it { should route(:get, '/routes/1/big').to(:action => 'big', :id => '1') }
    it { should route(:post, '/routes/1/rate').to(:action => 'rate', :id => '1') }

    #TODO verificar que son redirigidos al NOT_FOUND 401
    it { should_not route(:get, '/routes/new').to(:action => 'new') }
    it { should_not route(:post, '/routes').to(:action => 'create') }
    it { should_not route(:get, '/routes/1/edit').to(:action => 'edit', :id => '1') }
    it { should_not route(:put, '/routes/1/update').to(:action => 'update', :id => '1') }
    it { should_not route(:delete, '/routes/1/destroy').to(:action => 'destroy', :id => '1') }
  end

  #  describe "route generation" do
  #    it "maps #index" do
  #      route_for(:controller => "routes", :action => "index").should == "/routes"
  #    end
  #
  #    it "maps #new" do
  #      route_for(:controller => "routes", :action => "new").should == "/routes/new"
  #    end
  #
  #    it "maps #show" do
  #      route_for(:controller => "routes", :action => "show", :id => "1").should == "/routes/1"
  #    end
  #
  #    it "maps #edit" do
  #      route_for(:controller => "routes", :action => "edit", :id => "1").should == "/routes/1/edit"
  #    end
  #
  #  it "maps #create" do
  #    route_for(:controller => "routes", :action => "create").should == {:path => "/routes", :method => :post}
  #  end
  #
  #  it "maps #update" do
  #    route_for(:controller => "routes", :action => "update", :id => "1").should == {:path =>"/routes/1", :method => :put}
  #  end
  #
  #    it "maps #destroy" do
  #      route_for(:controller => "routes", :action => "destroy", :id => "1").should == {:path =>"/routes/1", :method => :delete}
  #    end
  #  end

  #  describe "route recognition" do
  #    it "generates params for #index" do
  #      params_from(:get, "/routes").should == {:controller => "routes", :action => "index"}
  #    end
  #
  #    it "generates params for #new" do
  #      params_from(:get, "/routes/new").should == {:controller => "routes", :action => "new"}
  #    end
  #
  #    it "generates params for #create" do
  #      params_from(:post, "/routes").should == {:controller => "routes", :action => "create"}
  #    end
  #
  #    it "generates params for #show" do
  #      params_from(:get, "/routes/1").should == {:controller => "routes", :action => "show", :id => "1"}
  #    end
  #
  #    it "generates params for #edit" do
  #      params_from(:get, "/routes/1/edit").should == {:controller => "routes", :action => "edit", :id => "1"}
  #    end
  #
  #    it "generates params for #update" do
  #      params_from(:put, "/routes/1").should == {:controller => "routes", :action => "update", :id => "1"}
  #    end
  #
  #    it "generates params for #destroy" do
  #      params_from(:delete, "/routes/1").should == {:controller => "routes", :action => "destroy", :id => "1"}
  #    end
  #  end
end
