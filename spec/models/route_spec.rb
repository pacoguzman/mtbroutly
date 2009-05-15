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

  describe "computing distance" do
    before :each do
      @route = Factory.build(:route, :user_id => 1)
    end

    it "set distance to 0 if the route doesn't have waypoints" do
      @route.distance.should == BigDecimal.new("0")
    end

    it "set distance to 0 if the route have only one waypoint" do
      @route.waypoints << Factory.build(:waypoint, :position => 1)
      @route.save!
      @route.distance.should == BigDecimal.new("0")
    end

    it "set distance if the route have at least two waypoints and no distance parameter is passed to route" do
      @route.waypoints << Factory.build(:waypoint, :position => 1)
      @route.waypoints << Factory.build(:near_waypoint, :position => 2)
      @route.save!
      @route.distance.should_not == BigDecimal.new("0")
    end

    it "no modify distance if the route have at least two waypoints and distance parameter is passed to route" do
      @route.distance = "1.215"
      @route.waypoints << Factory.build(:waypoint, :position => 1)
      @route.waypoints << Factory.build(:near_waypoint, :position => 2)
      @route.save!
      @route.distance.should == BigDecimal.new("1.215")
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
        search.conditions.sanitize.size.should == 3
      end

      it "should return no empty array if passed a keywords parameter" do
        search = Route.search(:keywords => "maya, azteca")
        search.conditions.sanitize.should be_kind_of(Array)
        search.conditions.sanitize.size.should == 5
      end

      it "should return empty hash if passed a keywords blank parameter" do
        Route.search(:keywords => "").conditions.conditions.should be_empty
      end
    end
    
  end

  describe "vertices methods to use with eschaton" do
    it "should return a array with a hash elements for each waypoint" do
      @route = Factory.build(:route, :user_id => 1)
      @route.waypoints << Factory.build(:waypoint, :position => 1, :lat => 9.9, :lng => 9.9)
      @route.waypoints << Factory.build(:waypoint, :position => 2, :lat => 9.8, :lng => 9.8)

      @route.vertices.should be_kind_of(Array)
      @route.vertices.should == [{:latitude => 9.9, :longitude => 9.9},{:latitude=> 9.8, :longitude => 9.8}]
    end
  end

  describe "points methods to use with eschaton" do
    it "should return a array with a array elements for each waypoint" do
      @route = Factory.build(:route, :user_id => 1)
      @route.waypoints << Factory.build(:waypoint, :position => 1, :lat => 9.9, :lng => 9.9)
      @route.waypoints << Factory.build(:waypoint, :position => 2, :lat => 9.8, :lng => 9.8)

      @route.points.should be_kind_of(Array)
      @route.points.each{ |point| point.should be_kind_of(Array) }
      @route.points.should == [[9.9, 9.9],[9.8, 9.8]]
    end
  end

  describe "coordinates methods to use with downloads" do
    it "should return a string with a coordinates for each waypoint" do
      @route = Factory.build(:route, :user_id => 1)
      @route.waypoints << Factory.build(:waypoint, :position => 1, :lat => 9.9, :lng => 9.9)
      @route.waypoints << Factory.build(:waypoint, :position => 2, :lat => 9.8, :lng => 9.8)

      @route.coordinates.should == "9.9,9.9,0.0 9.8,9.8,0.0"
    end
  end

  describe "encoded_vertices methods" do
    it "should return a string with encoded vertices" do
      @route = Factory.build(:route, :user_id => 1)
      @route.waypoints << Factory.build(:waypoint, :position => 1, :lat => 9.9, :lng => 9.9)
      @route.waypoints << Factory.build(:waypoint, :position => 2, :lat => 9.8, :lng => 9.8)

      @route.encoded_vertices.should be_kind_of(String)
    end

    it "should return nil for route without waypoints" do
      @route = Factory.build(:route, :user_id => 1)
      @route.encoded_vertices.should be_blank
    end
  end

  describe "waypoints for static map" do

    describe "in a route with 200 waypoints" do
      before :each do
        @route = Factory.build(:route, :user_id => 1)
        1.upto(200) do |i|
          @route.waypoints << Factory.build(:waypoint, :position => i)
        end
      end
     
      #TODO parámetro de configuración
      it "should return less or equal 70 waypoints" do
        @route.waypoints_for_static_map.size.should <= Route::STATIC_MAP_GOOGLE_LIMIT
      end

      it "should return the first waypoint in the first place" do
        @route.waypoints_for_static_map.first.should == @route.waypoints.first
      end

      it "should return the last waypoint in the last place" do
        @route.waypoints_for_static_map.last.should == @route.waypoints.last
      end
    end

    describe "in a route with 2 waypoints" do
      before :each do
        @route = Factory.build(:route, :user_id => 1)
        @route.waypoints << Factory.build(:waypoint, :position => 1, :lat => 9.9, :lng => 9.9)
        @route.waypoints << Factory.build(:waypoint, :position => 2, :lat => 9.8, :lng => 9.8)
      end

      it "should be equal waypoints and waypoints for static map" do
        @route.waypoints_for_static_map.should == @route.waypoints
      end
    end
  end
end
