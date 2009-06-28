class AddRouteLatAndLng < ActiveRecord::Migration
  def self.up
    add_column :routes, :lat, :decimal, :default => 0, :precision => 15, :scale => 10
    add_column :routes, :lng, :decimal, :default => 0, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :routes, :lat
    remove_column :routes, :lng
  end
end
