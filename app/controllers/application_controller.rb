# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  #  #TODO el meta language en función del lenguaje de la página
  #  #TODO los valores por defecto que hagan referencia al nombre final de la aplicación
  #  meta  :title        => "MTBRoutes",
  #    :description  => "MTBRoutes community",
  #    :keywords     => "mtb, routes, route, mountain bike, bike, bikes",
  #    :author => "Riding to NoWhere",
  #    :language => "en"

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5c2db7b94b53292eadd80538225cd32d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password  

  # Overloading tog_core application controller. Now use assets_packager tasks
  def set_javascripts_and_stylesheets
    @javascripts = %w()
    @stylesheets = %w()
    @feeds = %w()
  end

  def client_ip_to_location
    @client_ip = request.remote_ip
    if @client_ip == '127.0.0.1' && RAILS_ENV == 'development'
       @client_ip = '84.77.137.93'
    end
    @client_location ||= Geokit::Geocoders::MultiGeocoder.geocode(@client_ip)
    logger.debug "* Client ip is: #{@client_ip}"
    logger.debug "* Client location is: #{@client_location.ll}" if @client_location.success?
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
