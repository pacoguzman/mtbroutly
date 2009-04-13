require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  it { should have_many(:routes) }
  it { should have_many(:favorites) }

  it "should be the favorite routes" do
    user = Factory :user, :login => 'chavez'
    user_favoriter = Factory :user, :login => 'obama'
    route = Factory :route, :user => user
    
    route.favorites.create!(:user => user_favoriter)

    user_favoriter.favorite_routes.should == [route]
  end


  it "should be seo_urls 'login' - friendly_url"
  describe "as ajaxful_rater" do
    it { should have_many(:rates) }
  end
  
end

