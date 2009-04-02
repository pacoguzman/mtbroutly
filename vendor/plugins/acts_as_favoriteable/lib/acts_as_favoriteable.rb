# ActsAsCommentable
module Mwd
  module Acts #:nodoc:
    module Favoriteable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

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
        # Mark as a favorite for user
        def is_liked_by!(other_user)
          return nil unless other_user 
          f = favorites.new(:user_id => other_user.id)
          return (f.save ? f : nil)
        end

        def is_not_liked_by!(other_user)
          return nil unless other_user
          f = favorites.find_by_user_id(other_user.id)
          f.destroy
        end
        
        # Is this a user's favorite?
        def is_liked_by?(other_user)
          return nil unless other_user
          return (not favorites.find_by_user_id(other_user.id).nil?)
        end
      end
      
    end
  end
end
