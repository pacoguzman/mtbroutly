class Waypoint < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true
  acts_as_mappable :auto_geocode => false

  validates_presence_of :lat
  validates_presence_of :lng
  validates_numericality_of :position, :only_integer => true, :greather_than_or_equal_to => 0
end