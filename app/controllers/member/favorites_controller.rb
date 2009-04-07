# Inspirado en communityengine favorites controller
# y en tog::core comments controller
class Member::FavoritesController < Member::BaseController
  #PENDING Temas de cache a tratar con un sweeper
  #cache_sweeper :favorite_sweeper, :only => [:create, :destroy]

  def create
    favoriteable = Favorite.find_favoriteable params[:favorite][:favoriteable_type], params[:favorite][:favoriteable_id]
    first_favorite = favoriteable.favorites.empty?

    @favorite = favoriteable.favorites.new(params[:favorite])
    @favorite.user= current_user
    @favorite.save
    
    respond_to do |format|    
      format.html { redirect_to request.referer }
      format.js {
        render :template => "favorites/create.rjs", :locals => {:favoriteable => favoriteable,
          :first_favorite => first_favorite }
      }
    end
  end

  def remove
    @favorite = Favorite.find params[:id], :include => :favoriteable
    
    if @favorite.destroy
      message = {:ok => 'Favorite removed' }
    else
      message = {:error => 'Error removing favorite'}
    end

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js {
        render :template => "favorites/remove.rjs", :locals => {:favoriteable =>  @favorite.favoriteable, :message => message}
      }
    end
  end
end
