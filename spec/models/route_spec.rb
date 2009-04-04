require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Route do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Route.create!(@valid_attributes)
  end
  
  it { should belong_to(:owner) }
  it { should belong_to(:user) }
  it { should have_many(:waypoints) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it "should validates_presence_of(:owner)"
  it "should_validate_uniqueness_of(:title)"

  it "should validate uniqueness of title route" do
    Route.create!(@valid_attributes)
  end

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
end
