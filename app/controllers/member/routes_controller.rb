class Member::RoutesController < Member::BaseController
  
  helper 'routes'
  before_filter :redirect_if_not_current_user, :only => [:create, :update]

  def index
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @routes = current_user.routes.paginate :include => :waypoints, :per_page => 10,
      :page => @page,
      :order => @order + " " + @asc
    #FIXME
    #@favorite_routes = current_user.favorite_routes.paginate :include => :waypoints, :per_page => 10,
    #  :page => @page,
    #  :order => @order + " " + @asc
  end

  def edit
    @route = current_user.routes.find(params[:id])
    #FIXME el flash me viene de otras acciones chequear
    flash.discard
  end

  def new
    @route = current_user.routes.new
  end

  def create
    @route = Route.new params[:route].except(:waypoints)
    prepare_nested_attributes params[:route]

    respond_to do |wants|
      if @route.save
        flash[:ok] = 'New route created.'
        wants.html { redirect_to route_path(@route) }
        #wants.json { render :json => @route.to_json(:include => :waypoints), :status => :created, :location => @route }
      else
        flash[:error] = 'Failed to create a new route.'
        logger.info "#{@route.errors.inspect}"
        wants.html { render :action => :new }
        #wants.json { render :json => @route.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @route = current_user.routes.find(params[:id])
    prepare_nested_attributes params[:route]

    respond_to do |wants|
      if @route.save
        wants.html do
          flash[:ok]='Route updated.'
          redirect_to route_path(@route)
        end
      else
        wants.html do
          flash[:error]= "Failed to updated the route"
          redirect_to route_path(@route)
        end
      end
    end
  end

  def destroy
    @route = current_user.routes.find(params[:id])

    @route.destroy
    respond_to do |wants|
      wants.html do
        flash[:ok]='Route deleted.'
        redirect_to member_routes_path
      end
    end
  end

  private
  def prepare_nested_attributes(params_route)
    @route.attributes = params_route.except(:waypoints) unless @route.new_record?
    if params_route[:waypoints]
      # Al no poder hacer mass_assignment las tratamos por separado
      waypoints = ActiveSupport::JSON.decode(params_route[:waypoints])
      wps = waypoints.collect{|wp| wp["waypoint"].to_options!.merge!(:route => @route) }
      # Se debe acceder con string ya que es lo que llega sino wp.to_options! para pasar a symbol
      # Se debe construir con la ruta asociada para que una location no este sin ruta.
      @route.waypoints.clear unless @route.new_record?
      @route.waypoints.build(locs)
    end
  end

  def redirect_if_not_current_user
    #FIXME con atribute accesor limitas que datos puedes modificar podría utilizarse?
    unless params[:route].blank?
      # Update action
      user_id = params[:route][:user_id].blank? ? nil : params[:route][:user_id]
    else
      # Create action
      user_id = params[:user_id].blank? ? nil : params[:user_id]
    end

    if user_id && user_id != current_user.id.to_s
      # El current_user intenta suplantar a otro usuario metiendo un parámetro que no es suyo
      self.current_user.forget_me if logged_in?
      cookies.delete :auth_token
      reset_session
      flash[:warning] = I18n.t("tog_user.sessions.sign_out") + "You're trying to suplant other user"
      redirect_to login_path
      return true
    end
    false
  end
end
