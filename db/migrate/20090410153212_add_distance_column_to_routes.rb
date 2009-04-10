class AddDistanceColumnToRoutes < ActiveRecord::Migration
  def self.up
    add_column :routes, :distance, :decimal, :precision => 10, :scale => 3, :default => 0
  end

  def self.down
    remove_column :routes, :distance
  end
end
