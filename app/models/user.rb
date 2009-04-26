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

   def self.ratings_for(rated, current_user)
     aux = rated.rates_with_dimension.where_user(current_user).all
     Rate.simplify_ratings(aux)
   end
end
