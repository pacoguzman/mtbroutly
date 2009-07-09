class Waypoint < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true
  acts_as_mappable :auto_geocode => false

  validates_presence_of :lat
  validates_presence_of :lng
  validates_numericality_of :position, :only_integer => true, :greather_than_or_equal_to => 0
  
  def vertice
    {:latitude => lat, :longitude => lng}
  end

  def point
    [lat.to_f, lng.to_f]
  end

  def coordinates_to_s
    alt.blank? ? "#{lat.to_s},#{lng.to_s},0.0" : "#{lat.to_s},#{lng.to_s},#{alt.to_s}"
  end

end