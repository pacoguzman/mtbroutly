module RoutesHelper

  #<input type="button" class="grey_button_rate_it" value="" onclick="Effect.toggle('rates','blind', {delay: 0, duration: 0.3}); Effect.toggle('rate','blind', {delay: 0.3, duration: 0.3}); return false" />
  def button_toggle_div(name,options={},html_options={})
    toggle_options = html_options.slice(:start_id, :end_id)
    html_options.except!(:start_id, :end_id)
    button_to_function(name, options, html_options) do |page|
      page.visual_effect :toggle_blind, toggle_options[:start_id], {:delay => 0, :duration => 0.3}
      page.visual_effect :toggle_blind, toggle_options[:end_id], {:delay => 0.3, :duration => 0.3}
    end
  end

  def tag_cloud_routes(classes)
    tags = Route.tag_counts
    return if tags.empty?
    max_count = tags.sort_by(&:count).last.count.to_f
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

  def newest_routes(limit = 5)
    Route.find(:all, :limit => limit, :order => 'updated_at desc')
  end

  def init_map_for(route, options = {})
    
    run_map_script do
      map = Google::Map.new(:controls => [:large_map_3D, :map_type],
        :center => :best_fit)

      if route.waypoints.any?
        map.add_marker(start_marker(route.waypoints.first))
        if options[:encoded] == true
          #FIXME not fit the map
          encoded_line = Google::Line.new :encoded => {:points => route.encoded_vertices ,
            :levels => 'PFHFGP'},
            :colour => 'blue', :opacity => 1, :thickness => 6

          map.add_line(encoded_line)
        else
          generate_js_polyline(route)
        end
        map.add_marker(end_marker(route.waypoints.last))
      else
        map.click do |script, location|
          map.open_info_window(:location => location, :text => "This route hasn't any waypoints")
        end
      end
      
    end
    
  end

  def init_map_form(options = {})
    run_map_script do
      #FIXME no funciona la geolocalización poor IP para centrar el mapa
      #FIXME eschaton no centra el mapa
      client_location = options[:client_location]
      if client_location && client_location.is_a?(Geokit::GeoLoc)
        center = client_location.to_hash.to_eschaton_center if client_location.success?
      end
      center ||= :best_fit
      logger.debug "Center: #{center}"
      map = Google::Map.new(:controls => [:large_map_3D, :map_type],
                            :center => center, :zoom => 8)


      map.enable_scroll_wheel_zoom!
      map.disable_double_click_zoom!
      map.enable_google_bar!

      obj = Eschaton::JavascriptObject.new
      obj << ''
      obj << 'distanceMarkers = [];'
      obj << 'firstPoint = "";'
      obj << 'firstPointMarker = "";'
      obj << ''
      obj << 'load_route();'
    end
  end

  def generate_js_polyline(route)
    obj = Eschaton::JavascriptObject.new
    obj << "var points = #{route.points.to_js.gsub(' ','')}"
    obj << "var gpoints = [];"
    obj << "jQuery.each(points, function(i, p){"
    obj << "  var point = new GLatLng(p[0], p[1])"
    obj << "  track_bounds.extend(point);"
    obj << "  gpoints.push(point);"
    obj << "});"
    obj << "line = new GPolyline(gpoints, '#0000ff', 5, 1);"
    obj << "map.addOverlay(line);"
    obj << "map_lines.push(line);"
  end

  #TODO define icons
  def start_marker(waypoint)
    {:location => { :latitude => waypoint.lat, :longitude => waypoint.lng }}
  end

  #TODO define icons
  def end_marker(waypoint)
    {:location => { :latitude => waypoint.lat, :longitude => waypoint.lng }}
  end

  def path(route)
    {:vertices => route.vertices, :colour => 'blue', :thickness => 6}
  end

  # Impone una limitación de 70 puntos en las rutas por lo que pasamos a
  # usar mapas normales pero sin posibilidad de edición
  def static_map_img_tag(route, options = {})
    options.symbolize_keys!
    wpoints = route.waypoints_for_static_map
    tag("img", build_src_for_static_map(wpoints, options))
  end

  def build_src_for_static_map(wpoints, options = {})
    base_options = {
      :size => "320x180",
      :maptype => "satellite",
      :path => "rgb:0x0000ff,weight:5",
      :key => Google::ApiKey.get
    }
    
    base_options[:markers] = "#{wpoints.first.lat},#{wpoints.first.lng},greens|#{wpoints.last.lat},#{wpoints.last.lng},red"
    wpoints.each{ |wp|
      base_options[:path] << "|#{wp.lat},#{wp.lng}"
    }

    src = ""
    base_options.each{|k,v| src += "#{k}=#{v}&"}
    {:src => "http://maps.google.com/staticmap?" + src + "sensor=false"}
  end
end
