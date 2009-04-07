# ActsAsCommentable
module Mwd
  module Acts #:nodoc:
    module Favoriteable #:nodoc:

      module ClassMethods
        def acts_as_favoriteable
          has_many :favorites, :as => :favoriteable, :dependent => :destroy
          include Mwd::Acts::Favoriteable::InstanceMethods
          extend Mwd::Acts::Favoriteable::SingletonMethods
        end
      end

      # This module contains class methods
      module SingletonMethods

      end

      # This module contains instance methods
      module InstanceMethods
        # Helper class method to look up all users for
        # favoriteable class name and favoriteable id.
        def find_users_for_favoriteable(favoriteable_str, favoriteable_id)
          User.all :joins => :favorites,
            :conditions => {
              :favorites => {:favoriteable_type => favoriteable_str, :favoriteable_id => favoriteable_id}
            }
        end
      end

    end
  end
end
