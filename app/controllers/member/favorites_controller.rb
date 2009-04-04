# Inspirado en communityengine favorites controller
# y en tog::core comments controller
class FavoritesController < Member::BaseController
  #PENDING Temas de cache a tratar con un sweeper
  #cache_sweeper :favorite_sweeper, :only => [:create, :destroy]

  #TODO rediseñar el tema del flash para manterner informado al usuario
  def create
    favoriteable = Favorite.find_favoriteable params[:favorite][:favoriteable_type], params[:favorite][:favoriteable_id]

    no_favorites = favoriteable.favorites.empty?
    first_favorite = false
    @favorite = favoriteable.favorites.new(params[:favorite])
    @favorite.user_id = current_user.id if !current_user.nil?
    
    respond_to do |format|
      if @favorite.save
        flash[:ok] = 'Favorite added'
        no_favorites ? first_favorite = true : first_favorite = false
      else
        flash[:error] = 'Error while saving your favorite'
      end
      format.html { redirect_to request.referer }
      format.js {
        #TODO spinner para saber que esta trabajando
        flash_to_flash_now
        render :template => "favorites/create.rjs", :locals => {:favoriteable => favoriteable,
          :first_favorite => first_favorite }
      }
    end
  end

  def remove
    @favorite = Favorite.find params[:id], :include => :favoriteable
    favoriteable = @favorite.favoriteable
    
    if @favorite.destroy
      flash[:ok] = 'Favorite removed'
    else
      flash[:error] = 'Error removing favorite'
    end

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js {
        #TODO cuando se quede sin favoriters que lo diga
        #TODO spinner para saber que esta trabajando
        flash_to_flash_now
        render :template => "favorites/remove.rjs", :locals => {:favoriteable => favoriteable}
      }
    end
  end
end
