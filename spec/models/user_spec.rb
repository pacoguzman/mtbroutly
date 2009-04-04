require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  it { should have_many(:routes) }
  it "should be seo_urls 'login' - friendly_url"

  describe "as ajaxful_rater" do
    it { should have_many(:rates) }
  end
  
end

