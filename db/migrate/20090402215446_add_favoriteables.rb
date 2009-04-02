class AddFavoriteables < ActiveRecord::Migration
  def self.up
   create_table :favorites do |t|
     t.integer :user_id, :favoriteable_id
     t.string :favoriteable_type
     t.timestamps
   end
   add_index :favorites, :user_id
   add_index :favorites, [:favoriteable_type, :favoriteable_id]
 end

 def self.down
   remove_index :favorites, :user_id
   drop_table :favorites
 end

end