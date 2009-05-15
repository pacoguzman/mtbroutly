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

   def rates_simplified_for(rated)
     Rate.simplify_rates(rated.rates_with_dimension.where_user(self).all)
   end
end
