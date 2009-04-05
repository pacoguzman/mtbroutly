class User < ActiveRecord::Base
  # Modificaciones TOG
  has_many :comments, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  # FIN modificaciones TOG

  has_many :routes
  # Este plugin no esta integrado en TOG
  # bhedana/acts_as_favoriteable
  #has_many :favorites

  seo_urls "login"
  ajaxful_rater
end
