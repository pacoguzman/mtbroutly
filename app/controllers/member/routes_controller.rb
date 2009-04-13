require 'crack/xml' # for just xml

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

  #Dependiendo del tipo de fichero su extensión
  #debemos declarar que entidades se corresponden con que modelos de la aplicación
  #Y de este modo poder utilizar un parseador general para los diferentes tipos de
  #ficheros
  def process_uploaded_file(file_param)
    filename = file_param.original_filename
    filedata = file_param.read
    fileextension = File.extname(filename)
    logger.info "Filename: #{filename}"
    logger.info "File extension: #{fileextension}"

    #TODO use Crack for parsing trails files
    #Crack::XML.parse(filedata)

    @route = Route.new(:user => current_user)
    doc = REXML::Document.new(filedata)
    process_doc(doc, filename, fileextension)

    logger.info "#{@route.inspect}"
    logger.info "#{@route.waypoints.size}"

    @route
  end

  def process_doc(doc, filename, fileextension)
    case fileextension
    when ".gpx" then process_gpx(doc, filename)
    when ".kml" then process_kml(doc, filename)
    when ".crs" then process_crs(doc, filename)
    end
  end

  # GPX descargados de Wikiloc
  def process_gpx(doc, filename)
    # Indicar que debe editar el titulo y la descripción de la ruta si no vienen en el fichero
    @route.title = doc.elements['gpx/trk[1]/name'].text if doc.elements['gpx/trk[1]/name']
    @route.title = filename if @route.title.blank?
    @route.description = doc.elements['gpx/trk[1]/desc'].text if doc.elements['gpx/trk[1]/desc']
    @route.description = @route.title if @route.description.blank?

    pos = 0
    doc.elements.each('gpx/trk[1]/trkseg[1]/trkpt') do |trkpt|
      way = Waypoint.new
      way.lat = trkpt.attributes['lat']
      way.lng = trkpt.attributes['lon']
      way.alt = trkpt.elements['ele'].text
      #way.at_time = Time.parse(trkpt.elements['time'].text)
      way.position = pos
      @route.waypoints << way
      pos += 1
    end
  end

  def process_kml(doc, filename)
    # Indicar que debe editar el titulo y la descripción de la ruta si no vienen en el fichero
    @route.title = doc.elements['kml/Document/name'].text if doc.elements['kml/Document/name']
    @route.title = filename if @route.title.blank?
    @route.description = doc.elements['kml/Document/description'].text if doc.elements['kml/Document/description']
    @route.description = @route.title if @route.description.blank?

    pos = 0
    doc.elements.each('kml/Document/Folder') do |folder|
      if folder.elements['name'].text == "Waypoints"
        folder.elements.each('Placemark') do |placemark|
          way = Waypoint.new
          coordinates = placemark.elements['Point/coordinates'].text.split(',')
          way.lng = coordinates[0]
          way.lat = coordinates[1]
          way.alt = coordinates[2]
          #way.at_time = Time.parse(placemark.elements['TimeStamp/when'].text)
          way.position = pos
          @route.waypoints << way
          pos += 1
        end
      end

    end
  end

  # CRS descargado de Wikiloc
  def process_crs(doc, filename)

    course = doc.elements["//Course[1]"]
    @route.title = course.elements["Name"].text
    @route.description = @route.name
    track = course.elements["Track"]
    pos = 0
    track.elements.each("Trackpoint") do |trackpoint|
      way = Waypoint.new
      way.lat = trackpoint.elements["Position/LatitudeDegrees"].text
      way.lng = trackpoint.elements["Position/LongitudeDegrees"].text
      way.alt = trackpoint.elements["AltitudeMeters"].text
      way.pos = pos
      @route.waypoints << way
      pos += 1
    end

  end
end
