class User < ActiveRecord::Base
  # Modificaciones TOG
  has_many :comments, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  # FIN modificaciones TOG

  has_many :routes

  has_many :favorites
  
  seo_urls "login"
  ajaxful_rater

  def favorite_routes
    favorites.where_type('Route').all.collect(&:favoriteable)
  end
end
