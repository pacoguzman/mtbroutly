require 'gmap_polyline_encoder'
require 'polyline_decoder'

class Route < ActiveRecord::Base
  cattr_accessor :encoded_priority
  @@encoded_priority = true
  SEARCH_DISTANCE_CODE_RANGE = {"0" => {},"1" => { :distance_lte => 10 },
    "2" => { :distance_gt => 10, :distance_lte => 25 }, "3" => { :distance_gt => 25, :distance_lte => 50 },
    "4" => { :distance_gt => 50 }}
  SEARCH_DISTANCE_OPTIONS_SELECT = {"Any" => "0", "less than 10 kms" => "1",
    "between 10 and 25 kms" => "2","between 25 and 50 kms" => "3","more than 50 kms" => "4"}
  STATIC_MAP_GOOGLE_LIMIT = 70

  #TODO attr_protected to attr_accessible

  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :user
  has_many :waypoints, :as => :locatable, :dependent => :destroy
  has_many :rates_with_dimension, :as => :rateable, :class_name => "Rate", :dependent => :destroy,
    :conditions => ['dimension IS NOT ?', nil]

  #FIXME
  #validates_presence_of :owner, :user
  validates_presence_of :title, :description, :distance
  validates_uniqueness_of :title
  validates_numericality_of :distance, :greater_than_or_equal_to => 0
  validates_presence_of :encoded_points, :message => "You should create a route before save"
  validates_presence_of :distance_unit
  validates_inclusion_of :distance_unit, :in => %w( km mi )
  validates_associated :waypoints

  after_save :set_waypoints

  seo_urls "title"
  ajaxful_rateable :stars => 5, :dimensions => [:difficulty, :landscape]

  acts_as_commentable

  acts_as_favoriteable
  has_many :favoriters, :through => :favorites, :source => :user, :uniq => :true
  
  acts_as_taggable

  #####################################################################
  # Always use distance and encoded points instead access to the waypoints
  # Only use waypoints for search capabilities
  #####################################################################
  def self.with_waypoints_priority(&block)
    Route.encoded_priority = false
    yield  
    Route.encoded_priority = true
  end


  def compute_distance!
    self.distance = compute_distance
  end

  # Calculate with geokit usefull functions so we need to save the route and
  # create its waypoints
  # Build the waypoints to calculate the distance without saving
  def compute_distance
    if Route.encoded_priority
      nways = decoded_points.size
      wpoints = decoded_points.collect do |dp|
        Waypoint.new(:lat => dp[0], :lng => dp[1])
      end
    else
      nways = waypoints.size
      wpoints = waypoints
    end

    dist = 0
    wpoints.each_with_index do |w,i|
      dist += w.distance_to(wpoints[i + 1]) unless i == nways - 1
    end
    if self.distance_unit == 'km'
      return dist * 1.609344 #No pilla que se utiliza kms por defecto
    end
    dist
  end

  def find_near(origin, options = {})
    if !origin.blank? && origin.instance_of?(Waypoint)
      options[:limit] ||= 5
      options.delete_if {|k,v| v.blank? }
      #FIXME  con :include => :route no devuelve la distance se debe hace run sort_by despuest
      options_default = { :include => :route, :origin => origin,
        :group => :route_id, :order => 'distance' }
      wps = Waypoint.all options_default.merge(options)
      wps.sort_by_distance_from(origin)
      # Incluir en el mapeo un atributo virtual que sea el campo de distancia calculado
      routes = []
      wps.each do |wp|
        wp.route.close = wp.distance;
        routes << wp.route unless wp != self
      end
      routes.compact # Se elimina el primer elemento que pusimos a nil
    end
  end
  alias find_close find_near

  def self.search(params = {})
    valid_keys = [:distance, :keywords]
    search = Route.new_search
    params.slice(*valid_keys).stringify_keys.each do |k,v|
      search.conditions = Route.send("#{k}_condition", v) unless v.blank?
    end
    search
  end

  # Using reload when use waypoints, to load the waypoints created after save the route
  def vertices(reload = false)
    if Route.encoded_priority
      decoded_points.collect{ |w| {:latitude => w[0], :longitude => w[1]} }
    else
      waypoints(reload).map(&:vertice)
    end
  end

  # Using reload when use waypoints, to load the waypoints created after save the route
  def points(reload = false)
    if Route.encoded_priority
      decoded_points.collect{ |w| [w[0].to_f, w[1].to_f] }
    else
      waypoints(reload).map(&:point)
    end
  end

  # Using reload when use waypoints, to load the waypoints created after save the route
  def coordinates(reload = false)
    if Route.encoded_priority
      decoded_points.collect{ |w| "#{w[0]},#{w[1]},0.0" }.join(" ")
    else
      waypoints(reload).map(&:coordinates_to_s).join(" ")
    end
  end

  def encoded_vertices(reload = false)
    if Route.encoded_priority
      encoded = { :points => encoded_points }
    else
      encoded = GMapPolylineEncoder.new.encode(points(reload))
    end
    encoded[:points] ||= nil
  end

  def decoded_points
    @decoded_points ||= PolylineDecoder.new.decode(self.encoded_points)
  end

  def num_points
    decoded_points.size
  end

  def points_for_static_map
    return decoded_points if num_points <= STATIC_MAP_GOOGLE_LIMIT && Route.encoded_priority
    return waypoints if num_points <= STATIC_MAP_GOOGLE_LIMIT && !Route.encoded_priority

    diezmador = (num_points/STATIC_MAP_GOOGLE_LIMIT) + 1
    a = (0..num_points-1).step(diezmador).collect
    # Se añade último elemento como fin de la ruta
    a << num_points-1 unless (a.last == num_points-1)

    if Route.encoded_priority
      eval("self.decoded_points.values_at(#{a.join(', ')})")
    else
      eval("self.waypoints.values_at(#{a.join(', ')})")
    end
  end

  def rate_all_dimensions(ratings, user)
    valid_ratings = ratings.symbolize_keys.slice(*self.class.options[:dimensions])
    self.class.options[:dimensions].each do |dimension|
      self.rate(ratings[dimension], user, dimension.to_s)
    end if valid_ratings.length == self.class.options[:dimensions].length
  end

  def total_rate_average
    #    avg = if cached && self.class.caching_average?(dimension)
    #      send(caching_column_name(dimension)).to_f
    #    else
    #      self.rates_sum(dimension).to_f / self.total_rates(dimension).to_f
    #    end
    #    avg.nan? ? 0.0 : avg

    avg = rates_with_dimension.all.sum(&:stars).to_f / rates_with_dimension.length.to_f
    avg.nan? ? 0.0 : avg
  end

  def total_rates_with_dimension
    rates_with_dimension.length / self.class.options[:dimensions].length
  end

  private

  #TODO comprobaciones para mantener solo códigos disponibles
  def self.distance_condition(distance_code = "0")
    SEARCH_DISTANCE_CODE_RANGE[distance_code]
  end

  def self.keywords_condition(keywords)
    keywords.blank? ? {} : {:group => [{:title_kw => keywords}, {:or_description_kw => keywords}]}
  end

  def set_waypoints
    decoded_points.each_with_index do |decoded_point, index|
      Waypoint.create!(:locatable => self, :lat => decoded_point[0], :lng => decoded_point[1], :position => index)
    end
  end
end
