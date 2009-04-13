class Route < ActiveRecord::Base
  SEARCH_DISTANCE_CODE_RANGE = {"0" => {},"1" => { :distance_lte => 10 },
    "2" => { :distance_gt => 10, :distance_lte => 25 }, "3" => { :distance_gt => 25, :distance_lte => 50 },
    "4" => { :distance_gt => 50 }}
  SEARCH_DISTANCE_OPTIONS_SELECT = {"Any" => "0", "less than 10 kms" => "1",
    "between 10 and 25 kms" => "2","between 25 and 50 kms" => "3","more than 50 kms" => "4"}
  STATIC_MAP_GOOGLE_LIMIT = 70

  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :user
  has_many :waypoints, :as => :locatable, :dependent => :destroy
  has_many :rates_with_dimension, :as => :rateable, :class_name => "Rate", :dependent => :destroy,
    :conditions => ['dimension IS NOT ?', nil]

  #FIXME
  #validates_presence_of :owner, :user
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  validates_numericality_of :distance, :greater_than_or_equal_to => 0
  validates_associated :waypoints

  before_save :compute_distance, :if => :compute_distance?

  seo_urls "title"
  ajaxful_rateable :stars => 5, :dimensions => [:difficulty, :landscape]

  acts_as_commentable

  acts_as_favoriteable
  has_many :favoriters, :through => :favorites, :source => :user, :uniq => :true
  
  acts_as_taggable

  def compute_distance?
    waypoints.size > 1 && (distance == BigDecimal("0"))
  end

  #PENDING pasarlo a la base de datos?
  #TODO es posible cachear el resultado como ?¿
  def compute_distance
    dist = 0
    nways = waypoints.size
    waypoints.each_with_index do |w,i|
      dist += w.distance_to(waypoints[i + 1]) unless i == nways - 1
    end
    self.distance = dist * 1.609 #No pilla que se utiliza kms por defecto
  end

  def self.search(params = {})
    valid_keys = [:distance, :keywords]
    search = Route.new_search
    params.slice(*valid_keys).stringify_keys.each do |k,v|
      search.conditions = Route.send("#{k}_condition", v) unless v.blank?
    end
    search
  end

  def vertices
    waypoints.collect{|w| w.vertice }
  end

  def coordinates
    waypoints.collect{ |w| w.coordinates_to_s }.join(" ") unless waypoints.empty?
  end

  #TODO memoize para memorizar métodos en memoria
  def num_waypoints
    @num_waypoints ||= waypoints.size
  end

  def waypoints_for_static_map
    if num_waypoints > STATIC_MAP_GOOGLE_LIMIT
      diezmador = (num_waypoints/STATIC_MAP_GOOGLE_LIMIT) + 1
      a = (0..num_waypoints-1).step(diezmador).collect
      #FIXME corregir los dos accesos al último por un calculo del indice para saber si se debería incluir o no
      # Se añade último elemento como fin de la ruta
      a << num_waypoints-1 unless (a.last == num_waypoints-1)
      eval("waypoints.values_at(#{a.join(', ')})")
    else
      waypoints
    end
  end

  private

  #TODO comprobaciones para mantener solo códigos disponibles
  def self.distance_condition(distance_code = "0")
    SEARCH_DISTANCE_CODE_RANGE[distance_code]
  end

  def self.keywords_condition(keywords)
    keywords.blank? ? {} : {:group => [{:title_kw => keywords}, {:or_description_kw => keywords}]}
  end
end
