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
end
