class Favorite < ActiveRecord::Base
  belongs_to :favoriteable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :favoriteable_id, :favoriteable_type
  validates_uniqueness_of :user_id, :scope => [:favoriteable_type, :favoriteable_id]
end
