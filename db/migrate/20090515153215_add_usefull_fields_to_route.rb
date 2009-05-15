class AddUsefullFieldsToRoute < ActiveRecord::Migration
  def self.up
    add_column :routes, :distance_unit, :string, :default => "km"
    add_column :routes, :loops, :boolean, :default => false
    add_column :routes, :encoded_points, :string
  end

  def self.down
    remove_column :routes, :distance_unit
    remove_column :routes, :loops
    remove_column :encoded_points
  end
end
