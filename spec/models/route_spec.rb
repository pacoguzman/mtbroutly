require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Route do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :user_id => 1,
      :created_at => Time.now,
      :updated_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Route.create!(@valid_attributes)
  end

  it { should have_many(:waypoints) }
  it { should have_many(:rates_with_dimension) }
  it { should belong_to(:owner) }

  it { should validates_presence_of(:title) }
  it { should validates_presence_of(:description) }
  it { should validates_presence_of(:owner) }

  it "should validate uniqueness of title route" do
    Route.create!(@valid_attributes)
    should_validate_uniqueness_of(:title)
  end

  it "should be seo_urls 'title'"
  it "should be acts_as_taggable"
  it "should be ajaxful_rateable"
end
