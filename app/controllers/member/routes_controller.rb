require 'crack/xml' # for just xml

class Member::RoutesController < Member::BaseController
  
  helper 'routes'
  before_filter :redirect_if_not_current_user, :only => [:create, :update]
  before_filter :client_ip_to_location, :only => [:new]

  def index
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @routes = current_user.routes.paginate :include => :waypoints, :per_page => 10,
      :page => @page,
      :order => @order + " " + @asc
    
    @favorite_routes = current_user.favorite_routes.paginate :include => :waypoints, :per_page => 10,
      :page => @page,
      :order => @order + " " + @asc
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
    @route = Route.new params[:route]
    @route.user = current_user

    build_route_from_hidden_fields params.except(:route)

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
    build_route_from_hidden_fields params.except(:route)

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

  def upload
  end

  def uploaded
    file_param = params[:file]
    @route = process_uploaded_file(file_param)

    respond_to do |wants|
      if @route && @route.save
        flash[:warning] = 'Route uploaded.'
        wants.html { redirect_to route_path(@route) }
      else
        flash[:error] = 'Failed to build a new route from the file uploaded.'
        wants.html { render :action => :upload }
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
  def build_route_from_hidden_fields(hidden_params = {})
    encoded_points = hidden_params[:route_encoded_points]
    unless encoded_points.blank?
      decoder = PolylineDecoder.new
      decoded_points = decoder.decode(encoded_points)
      decoded_points.each do |point|
        @route.waypoints << Waypoint.new(:lat => point[0], :lng => point[1], :position => pos ||= 1)
        pos += 1
      end
    else
      @route.errors.add(:waypoints, "You have to specify a route path")
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
