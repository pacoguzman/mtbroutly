class Rate < ActiveRecord::Base
  belongs_to :user
  belongs_to :rateable, :polymorphic => true

  named_scope :where_user, lambda { |u| { :conditions => { :user_id => u.id } } }

  
  attr_accessible :rate, :dimension

  # {:dim1 => stars_dim1, :dim2 => stars_dim2}
  def self.simplify_ratings(user_ratings)
    #FIXME use yield maybe?¿
    rating = {}
    user_ratings.each do |r|
      rating.merge!({r.dimension.to_sym => r.stars})
    end
    rating
  end
end

