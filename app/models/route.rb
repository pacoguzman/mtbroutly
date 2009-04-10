class Route < ActiveRecord::Base
  SEARCH_DISTANCE_CODE_RANGE = {"0" => {},"1" => { :distance_lte => 10 },
    "2" => { :distance_gt => 10, :distance_lte => 25 }, "3" => { :distance_gt => 25, :distance_lte => 50 },
    "4" => { :distance_gt => 50 }}
  SEARCH_DISTANCE_OPTIONS_SELECT = {"Any" => "0", "less than 10 kms" => "1",
              "between 10 and 25 kms" => "2","between 25 and 50 kms" => "3","more than 50 kms" => "4"}

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

  #PENDING pasarlo a la base de datos?
  #TODO es posible cachear el resultado como ?¿
  def compute_distance
    dist = 0
    nways = waypoints.size
    waypoints.each_with_index do |w,i|
      dist += w.distance_to(waypoints[i + 1]) unless i == nways - 1
    end
    return (dist * 1.609) #No pilla que se utiliza kms por defecto
  end

  def compute_distance!
    update_attribute(:distance, compute_distance)
  end
  
  def self.search(params = {})
    valid_keys = [:distance, :keywords]
    search = Route.new_search
    params.slice(*valid_keys).stringify_keys.each do |k,v|
      search.conditions = Route.send("#{k}_condition", v) unless v.blank?
    end
    search
  end

  private

  #TODO comprobaciones para mantener solo códigos disponibles
  def self.distance_condition(distance_code = "0")
    SEARCH_DISTANCE_CODE_RANGE[distance_code]
  end

  def self.keywords_condition(keywords)
    {:group => [{:title_kw => keywords}, {:or_description_kw => keywords}]}
  end
end
