class CreateWaypoints < ActiveRecord::Migration
  def self.up
    create_table :waypoints do |t|
      t.string :address, :limit => 100
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.decimal :alt, :precision => 5, :scale => 5
      t.references :locatable, :polymorphic => true
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :waypoints
  end
end
