class RoutesController < ApplicationController
  before_filter :login_required, :only => [:created_by_you, :close_to_you, :your_favorites, :rate]

  # GET /routes
  # GET /routes.xml
  def index
    @routes_title = "Routes"
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    conditions = params[:user_id] ? {:user_id => params[:user_id].split('-').first} : {}

    @routes = Route.paginate :include => :waypoints, :conditions => conditions, :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routes }
    end
  end

  # GET /routes/1
  # GET /routes/1.xml
  def show
    @route = Route.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @route }
    end
  end

 def all_by_tag
    @tag  = Tag.find_by_name(params[:tag_name])
    if !@tag.nil?
      @routes_title = "Routes tagged with #{@tag.name}"
      @order = params[:order] || 'name'
      @page = params[:page] || '1'
      @asc = params[:asc] || 'asc'
      @routes = Route.find_tagged_with(@tag#,
        #:conditions => ['posts.blog_id=? and posts.state=?', @blog, "published"]
      ).paginate :per_page => 10,
        :page => @page,
        :order => @order + " " + @asc
    end

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Rating de las rutas con ajaxful-rating + starbox
  def rate
    @route = Route.find(params[:id])
    @route.rate_all_dimensions(params[:rating], current_user)

    render :update do |page|
      page.hide "rate"
      page.replace "rates", :partial => "shared/rates", :locals => {:rated => @route}
      page.show "rates"
      page.visual_effect :highlight, "rates"
      page << javascript_rating(@route, params[:rating])
    end
  end

  # Listado de las última rutas creadas
  # No es necesario estar logueado
  def newest
    @routes_title = "New Routes"
    @order = 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @routes = Route.paginate :include => :waypoints, :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Listado de las rutas mejor valoradas
  # No es necesario estar logueado
  def highlighted
    @routes_title = "Highlighted Routes"
    @order = 'highlight'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
#    @routes = Route.paginate :joins => :rates_with_dimension, :group => :id,
#      :select => "routes.*, sum(stars) as highlight", :per_page => 10,
#      :page => @page,
#      :order => @order + " " + @asc
    # Se seleccionan rutas sin que tengan valoración, devolviendo highligh = nil
    @routes =  Route.paginate :joins => "LEFT JOIN 'rates' ON 'rates'.rateable_id = 'routes'.id " +
      "AND 'rates'.rateable_type = 'Route' AND dimension IS NOT NULL", :group => :id,
      :select => "routes.*, sum(stars) as highlight", :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Listado de tus rutas
  # Es necesario estar logueado
  def created_by_you
    @routes_title = "Routes Created By You"
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @routes = current_user.routes.paginate :include => :waypoints, :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Listado de tus rutas
  # Es necesario estar logueado
  def close_to_you
    @routes_title = "Routes Close To You"
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    #TODO  #@origin = current_user.profile.location
    @routes = Routes.paginate :include => :waypoints, :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Listado de rutas favoritas
  # Es necesario estar logueado
  def your_favorites
    @routes_title = "Your Favorite Routes"
    @order = params[:order] || 'updated_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @routes = current_user.favorite_routes.paginate :include => :waypoints, :per_page => '10',
      :page => @page,
      :order => @order + " " + @asc

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  def big
    @route = Route.find params[:id], :include => :waypoints
  end

  def show
    @page = params[:page] || '1'
    @route = Route.find params[:id], :include => :waypoints
    # Variable para saber si es ruta favorita del usuario
    @favorite = current_user.nil? ? [] : @route.favorites.find_by_user_id(current_user.id)
    #@routes_near = @route.find_near

    respond_to do |format|
      format.html
      format.xml  { render :xml => @route }
      format.atom { render(:layout => false) }
      format.kml { render(:layout => false) }
      format.gpx { render(:layour => false) }
      format.crs { render(:layour => false) }
      #format.georss {  render(:layout => false) }
    end
  end

  #FIXME add include locations for the searched routes
  def search
    @routes_title = "Routes"

    @order = params[:order] || 'name'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'asc'

    @routes = Route.all(:include => :waypoints,
      :conditions => compute_searchlogic_conditions(params[:search])).paginate( :paginate => '10',
      :page => @page,
      :order => @order + " " + @asc)
    # Versión de searchlogic pero implica modificar la paginación
    # se debe utilizar la que implemente searchlogic
    #    @routes = Route.all(:include => :locations,
    #      :conditions =>compute_searchlogic_conditions(params[:search]),
    #      :per_page => 10,
    #      :page => @page,
    #      :order_by => @order,
    #      :order_as => @asc
    #    )

    respond_to do |format|
      format.html { render :template => "routes/index"}
      format.xml  { render :xml => @routes }
    end
  end

  # Métodos utilizados en los controladores Member
  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  private
  def bad_record
    render :template => "member/site/not_found"
  end

  def compute_searchlogic_conditions(search = {})
    conditions = {}
    conditions.merge!(distance_condition(search[:distance])) unless search[:distance].blank?
    conditions.merge!(keywords_condition(search[:keywords])) unless search[:keywords].blank?
  end

  def distance_condition(distance_code)
    distance_code ||= "0"
    case distance_code
    when "0"
      {}
    when "1"
      return { :distance_lte => 10 }
    when "2"
      return { :distance_gt => 10, :distance_lte => 25 }
    when "3"
      return { :distance_gt => 25, :distance_lte => 50 }
    when "4"
      return { :distance_gt => 50 }
    end
  end

  def keywords_condition(keywords)
    {:group => [{:name_kw => keywords}, {:or_description_kw => keywords}]}
  end
end
