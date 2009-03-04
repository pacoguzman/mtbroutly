class Waypoint < ActiveRecord::Base
  belongs_to :locatable, :polymorphib => true
end
