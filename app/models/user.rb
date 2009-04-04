class User < ActiveRecord::Base
  has_many :routes
  # Este plugin no esta integrado en TOG
  # bhedana/acts_as_favoriteable
  #has_many :favorites

  seo_urls "login"
  ajaxful_rater
end
