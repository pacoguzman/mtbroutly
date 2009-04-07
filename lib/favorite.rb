class Favorite < ActiveRecord::Base
  # Helper class method to lookup all favorites assigned
  # to all favoriteable types for a given user.
  def self.find_favorites_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up all favorites for
  # favoriteable class name and favoriteable id.
  def self.find_favorites_for_favoriteable(favoriteable_str, favoriteable_id)
    find(:all,
      :conditions => ["favoriteable_type = ? and favoriteable_id = ?", favoriteable_str, favoriteable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a favoriteable object
  # given the favoriteable class name and id
  def self.find_favoriteable(favoriteable_str, favoriteable_id)
    favoriteable_str.constantize.find(favoriteable_id)
  end
end
