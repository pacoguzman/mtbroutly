class Route < ActiveRecord::Base
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :user
  has_many :waypoints, :as => :locatable
  has_many :rates_with_dimension, :as => :rateable, :class_name => "Rate", :dependent => :destroy,
    :conditions => ['dimension IS NOT ?', nil]

  validates_presence_of :title, :description, :owner#:user
  validates_uniqueness_of :title

  seo_urls "title"
  acts_as_taggable
  ajaxful_rateable :stars => 5, :dimensions => [:difficulty, :landscape]
end
