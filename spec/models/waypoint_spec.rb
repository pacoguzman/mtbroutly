require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Waypoint do

  it "should create a new instance given valid attributes" do
    Factory.create(:waypoint)
  end

  it { should belong_to :locatable }
  it { should validate_presence_of :lat } 
  it { should validate_presence_of :lng }
  it { should validate_numericality_of :position }

  it "should return a hash from vertice to use with eschaton" do
    Factory.create(:waypoint, :lat => 9.99, :lng => 9.99).vertice.should ==  {:latitude => 9.99, :longitude => 9.99}
  end

  describe "coordinates_to_s method to use with static map" do
    it "should return a valid string with nil altitude" do
      way = Factory.create(:waypoint, :lat => 9.99, :lng => 9.99, :alt => nil)
      way.coordinates_to_s.should == "9.99,9.99,0.0"
    end

    it "should return a valid string with not nil altitude" do
      way =  Factory.create(:waypoint, :lat => 9.99, :lng => 9.99, :alt => 9.99)
      way.coordinates_to_s.should == "9.99,9.99,9.99"
    end
  end
  
end
