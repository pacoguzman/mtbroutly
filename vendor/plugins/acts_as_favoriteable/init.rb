# Include hook code here
require 'acts_as_favoriteable'
ActiveRecord::Base.send(:include, Mwd::Acts::Favoriteable)
