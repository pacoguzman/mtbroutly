require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Route do
  
  it "should create a new instance given valid attributes" do
    Factory.create(:route, :user_id => 1)
  end
  
  it { should belong_to(:owner) }
  it { should belong_to(:user) }
  it { should have_many(:waypoints) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:distance) }
  it { should validate_presence_of(:encoded_points).with_message("You should create a route before save") }
  it "should validate_presence_of(:owner)"
  it "should_validate_uniqueness_of(:title)"

  it { should validate_numericality_of(:distance) }
  it "should validate_associated(:waypoints)"

  it "should be seo_urls 'title' - friendly_url"

  describe "as rateable" do
    it { should have_many(:rates_with_dimension) }
    it "should have_instance_method :rate"
    it "should have_instance_method :raters"
    it "should have_instance_method :rate_by"
    it "should have_instance_method :rate_by?"
    it "should have_instance_method :total_rates"
    it "should have_instance_method :rates_sum"
  end

  describe "as commentable" do
    it { should have_many(:comments) }
  end

  describe "as favoriteable" do
    it { should have_many(:favorites) }
  end

  describe "as taggable" do
    it { should have_many(:tags) }
  end

  describe "creating waypoints" do
    before :each do
      @route = Factory.build(:route, :user_id => 1)
    end

    it "should save the route" do
      @route.save.should == true
    end

    it "should decoded the encoded points in two points" do
      decoded_points = @route.decoded_points
      decoded_points.should have(2).items
    end

    it "should have two waypoints" do
      @route.save
      Route.find_by_title(@route.title).should have(2).waypoints
    end

    it "should decode correctly the encoded points in waypoints" do
      decoded_points = @route.decoded_points
      decoded_points.first.should be_as_point([40.30720, -3.7957], 0.001)
      decoded_points.last.should be_as_point([40.30738, -3.79612], 0.001)
    end

    it "should save correctly the decoded points in waypoints" do
      @route.save
      route = Route.find_by_title(@route.title)
      first_waypoint = route.waypoints.first
      first_decoded_point = route.decoded_points[0]
      first_waypoint.lat.should be_close(first_decoded_point[0], 0.001)
      first_waypoint.lng.should be_close(first_decoded_point[1], 0.001)
    end
  end

  describe "computing distance" do
    before :each do
      @route = Factory.build(:route, :user_id => 1)
    end
  end

  describe "find_near method" do
    it "should describe some functionality to finding near route from other"
  end

  describe "search capabilities" do

    describe "distance parameter" do
      it "should return no empty hash if passed a valid distance code and diferent to '0'" do
        Route.search(:distance => "1").conditions.conditions.should_not be_empty
      end

      it "should return empty hash if passed a valid distance code equal to '0'" do
        Route.search(:distance => "0").conditions.conditions.should be_empty
      end

      it "should return empty hash if passed an invalid distance code" do
        Route.search(:distance => -1).conditions.conditions.should be_empty
      end
    end

    describe "keywords parameter" do
      it "should return no empty array if passed a keywords parameter" do
        search = Route.search(:keywords => "maya")
        search.conditions.sanitize.should be_kind_of(Array)
        search.conditions.sanitize.should have(3).items
      end

      it "should return no empty array if passed a keywords parameter" do
        search = Route.search(:keywords => "maya, azteca")
        search.conditions.sanitize.should be_kind_of(Array)
        search.conditions.sanitize.should have(5).items
      end

      it "should return empty hash if passed a keywords blank parameter" do
        Route.search(:keywords => "").conditions.conditions.should be_empty
      end
    end
    
  end

  describe "vertices methods to use with eschaton" do
    describe "using encoded_points" do
      it "should return a array with a hash elements for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.vertices.should be_kind_of(Array)
        #FIXME matcher or macro for this kind of comparision
        #@route.vertices.should == [{:latitude=> 40.30720, :longitude => -3.7957},
        #  {:latitude => 40.30738, :longitude => -3.79612}]
        @route.vertices.first.should be_as_vertice([40.30720, -3.7957], 0.001)
        @route.vertices.last.should be_as_vertice([40.30738, -3.79612], 0.001)
      end
    end
    describe "using waypoints" do
      it "should return a array with a hash elements for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.save
        Route.with_waypoints_priority do
          #FIXME matcher or macro for this kind of comparision
          #@route.vertices.should == [{:latitude=> 40.30720, :longitude => -3.7957},
          #  {:latitude => 40.30738, :longitude => -3.79612}]
          #route = Route.find_by_title(@route.title)
          @route.vertices(true)
          @route.vertices.first.should be_as_vertice([40.30720, -3.7957], 0.001)
          @route.vertices.last.should be_as_vertice([40.30738, -3.79612], 0.001)
        end
      end
    end
  end

  describe "points methods to use with eschaton" do
    describe "using encoded_points" do
      it "should return a array with a array elements for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.points.should be_kind_of(Array)
        @route.points.each{ |point| point.should be_kind_of(Array) }
        #FIXME to compare this kind of object
        @route.points.first.should be_as_point([40.30720, -3.7957], 0.001)
        @route.points.last.should be_as_point([40.30738, -3.79612], 0.001)
      end
    end

    describe "using waypoints" do
      it "should return a array with a array elements for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.save
        Route.with_waypoints_priority do
          #FIXME matcher or macro for this kind of comparision
          #@route.vertices.should == [{:latitude=> 40.30720, :longitude => -3.7957},
          #  {:latitude => 40.30738, :longitude => -3.79612}]
          #route = Route.find_by_title(@route.title)
          @route.points(true)
          @route.points.should be_kind_of(Array)
          #FIXME to compare this kind of object
          @route.points.first.should be_as_point([40.30720, -3.7957], 0.001)
          @route.points.last.should be_as_point([40.30738, -3.79612], 0.001)
        end
      end
    end
  end

  describe "coordinates methods to use with downloads" do
    describe "using encoded_points" do
      it "should return a string with a coordinates for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.coordinates.should == "40.3072,-3.7957,0.0 40.30738,-3.79612,0.0"
      end
    end

    describe "using waypoints" do
      it "should return a string with a coordinates for each waypoint" do
        @route = Factory.build(:route, :user_id => 1)
        @route.save
        Route.with_waypoints_priority do
          @route.coordinates(true).should == "40.3072,-3.7957,0.0 40.30738,-3.79612,0.0"
        end
      end
    end
  end

  describe "encoded_vertices methods" do
    it "should return a string with encoded vertices" do
      @route = Factory.build(:route, :user_id => 1)
      @route.encoded_vertices.should be_kind_of(String)
    end
  end

  describe "waypoints for static map" do

    describe "in a route with 585 waypoints" do
      before :each do
        @route = Factory.build(:route_long, :user_id => 1)
      end
      
      describe "using encoded_points" do
        it "should return less or equal 70 waypoints" do
          @route.points_for_static_map.should have_at_most(Route::STATIC_MAP_GOOGLE_LIMIT).items
        end

        it "should return the first waypoint in the first place" do
          @route.points_for_static_map.first.should == @route.decoded_points.first
        end

        it "should return the last waypoint in the last place" do
          @route.points_for_static_map.last.should == @route.decoded_points.last
        end
      end

      describe "using waypoints" do
        before :each do
          @route.save
          @route.waypoints(true)
        end
        it "should return less or equal 70 waypoints" do
          Route.with_waypoints_priority do
           @route.points_for_static_map.should have_at_most(Route::STATIC_MAP_GOOGLE_LIMIT).items
          end
        end

        it "should return the first waypoint in the first place" do
          Route.with_waypoints_priority do
           @route.points_for_static_map.first.should == @route.waypoints.first
          end
        end

        it "should return the last waypoint in the last place" do
          Route.with_waypoints_priority do
           @route.points_for_static_map.last.should == @route.waypoints.last
          end
        end
      end
    end

    describe "in a route with 2 waypoints" do
      before :each do
        @route = Factory.build(:route, :user_id => 1)
      end
      describe "using encoded_points" do
        it "should be equal encoded_points and points for static map" do
          @route.points_for_static_map.should == @route.decoded_points
        end
      end
      describe "using waypoints" do
        it "should be equal waypoints and points for static map" do
          @route.save
          Route.with_waypoints_priority do
            @route.waypoints(true)
            @route.points_for_static_map.should == @route.waypoints
          end
        end
      end
    end
  end
end
