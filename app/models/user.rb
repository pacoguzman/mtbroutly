class User < ActiveRecord::Base
  seo_urls "login"

  has_many :routes
  # Este plugin no esta integrado en TOG
  # bhedana/acts_as_favoriteable
  #has_many :favorites

  ajaxful_rater
end
