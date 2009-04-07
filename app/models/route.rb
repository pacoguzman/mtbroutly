class Route < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :user
  has_many :waypoints, :as => :locatable
  has_many :rates_with_dimension, :as => :rateable, :class_name => "Rate", :dependent => :destroy,
    :conditions => ['dimension IS NOT ?', nil]

  #FIXME
  #validates_presence_of :owner, :user
  validates_presence_of :title, :description
  validates_uniqueness_of :title

  seo_urls "title"
  ajaxful_rateable :stars => 5, :dimensions => [:difficulty, :landscape]

  acts_as_commentable

  acts_as_favoriteable
  has_many :favoriters, :through => :favorites, :source => :user, :uniq => :true
  
  acts_as_taggable
end
