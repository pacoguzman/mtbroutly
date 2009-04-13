require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Waypoint do
  before(:each) do
    @valid_attributes = {
      :address => "value for address",
      :lat => 9.99,
      :lng => 9.99,
      :alt => 9.99,
      :locatable_id => 1,
      :locatable_type => "value for locatable_type",
      :position => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Waypoint.create!(@valid_attributes)
  end

  it { should belong_to :locatable }
  it { should validate_presence_of :lat } 
  it { should validate_presence_of :lng }
  it { should validate_numericality_of :position }

  it "should return a hash from vertice to use with eschaton" do
    hash = {:latitude => 9.99, :longitude => 9.99}
    Waypoint.create!(@valid_attributes).vertice.should == hash
  end

  describe "coordinates_to_s method to use with static map" do
    it "should return a valid string with nil altitude" do
      @way = Waypoint.create!(@valid_attributes.merge!(:alt => 0.0))
      @way.coordinates_to_s.should == "9.99,9.99,0.0"
    end

    it "should return a valid string with not nil altitude" do
      @way = Waypoint.create!(@valid_attributes)
      @way.coordinates_to_s.should == "9.99,9.99,9.99"
    end
  end
  
end
