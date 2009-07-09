class AddUsefullFieldsToRoute < ActiveRecord::Migration
  def self.up
    add_column :routes, :distance_unit, :string, :default => "km"
    add_column :routes, :loops, :integer, :default => 1
    add_column :routes, :encoded_points, :text, :default => ""
  end

  def self.down
    remove_column :routes, :distance_unit
    remove_column :routes, :loops
    remove_column :encoded_points
  end
end
