module Google
  
  # Represents a marker that can be added to a Map using Map#add_marker. If a method or event is not documented here please 
  # see googles online[http://code.google.com/apis/maps/documentation/reference.html#GMarker] docs for details. See MapObject#listen_to on how to use
  # events not listed on this object.
  #
  # You will most likely use click, open_info_window and set_tooltip to get some basic functionality going.
  #
  # === General examples:
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5}, 
  #                     :draggable => true,
  #                     :title => "This is a marker!"
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :icon => :green_circle #=> "/images/green_circle.png"
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :icon => '/images/red_dot.gif'
  #
  # === Tooltip examples:
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:text => 'This is sparta!'}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:text => 'This is sparta!', :show => :always}
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :tooltip => {:partial => 'spot_information', :show => :always}
  #
  # === Gravatar examples:
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :gravatar => 'yawningman@eschaton.com'
  #
  #  Google::Marker.new :location => {:latitude => -34, :longitude => 18.5},
  #                     :gravatar => {:email_address => 'yawningman@eschaton.com', :size => 50}
  #
  # === Circle examples:
  #  Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
  #                     :circle => true
  #
  #  Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
  #                     :circle => {:radius => 500, :border_width => 5}
  #
  # === Info windows using open_info_window:
  #
  #  marker.open_info_window :text => 'Hello there...'
  #
  #  marker.open_info_window :partial => 'spot_information'
  #
  #  marker.open_info_window :partial => 'spot_information', :locals => {:information => information}
  #
  #  map.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
  #
  # === Using the click event:
  #  
  #  # Open a info window and circle the marker.
  #  marker.click do |script|
  #    marker.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
  #    marker.circle!
  #  end
  class Marker < MapObject
    attr_accessor :icon
    attr_reader :circle, :circle_var
    
    include Tooltipable
    
    # ==== Options:
    # * +location+ - Required. A Location or whatever Location#new supports which indicates where the marker must be placed on the map.
    # * +icon+ - Optional. The Icon that should be used for the marker otherwise the default marker icon will be used.
    # * +gravatar+ - Optional. Uses a gravatar as the icon. If a string is supplied it will be used for the +email_address+ 
    #   option, see Gravatar#new for other valid options.
    # * +circle+ - Optional. Indicates if a circle should be drawn around the marker, also supports styling options(see Circle#new)
    # * +tooltip+ - Optional. See Google::Tooltip#new for valid options.
    #
    # See addtional options[http://code.google.com/apis/maps/documentation/reference.html#GMarkerOptions] that are supported.
    def initialize(options = {})
      options.default! :draggable => false

      super

      @circle_var = "circle_#{self}"      

      if create_var?
        location = Google::OptionsHelper.to_location(options.extract(:location))

        self.icon = if icon = options.extract(:icon)
                      Google::OptionsHelper.to_icon(icon)
                    elsif gravatar = options.extract(:gravatar)
                      Google::OptionsHelper.to_gravatar_icon(gravatar)
                    end

        options[:icon] = self.icon if self.icon
        
        circle_options = options.extract(:circle)
        tooltip_options = options.extract(:tooltip)
        
        self << "#{self.var} = new GMarker(#{location}, #{options.to_google_options});"

        self.draggable = options[:draggable]
        self.set_tooltip(tooltip_options) if tooltip_options

        if circle_options
          circle_options = {} if circle_options == true
          self.circle! circle_options
        end
      end
    end
    
    # The location at which the marker is currently placed on the map.
    def location
      "#{self}.getLatLng()"
    end

    # Opens a information window on the marker using either +url+, +partial+ or +text+ options as content.
    #
    # ==== Options:
    # * +url+ - Optional. URL is generated by rails #url_for. Supports standard url arguments and javascript variable interpolation.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be 
    #   placed inside the info window.
    # * +text+ - Optional. The html content that will be placed inside the info window.
    # * +include_location+ - Optional. Works in conjunction with the +url+ option and indicates if latitude and longitude parameters of
    #   +location+ should be sent through with the +url+, defaulted to +true+. Use <tt>params[:location]</tt> or <tt>params[:location][:latitude]</tt> and <tt>params[:location][:longitude]</tt> in your action.
    # ==== Examples:
    #
    #  marker.open_info_window :text => 'Hello there...'
    #
    #  marker.open_info_window :partial => 'spot_information'
    #
    #  marker.open_info_window :partial => 'spot_information', :locals => {:information => information}
    #
    #  map.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
    def open_info_window(options)
      info_window = InfoWindow.new(:object => self)
      info_window.open_on_marker options
    end
    
    # Supports all the same options as open_info_window. The info window is then cached so that every time the marker is 'clicked'
    # it will open up the cached info window. The cached info window can also be opened using open_cached_info_window.
    def cache_info_window(options)
      info_window = InfoWindow.new(:object => self)
      info_window.cache_on_marker options
    end

    def open_cached_info_window
      self << "GEvent.trigger(#{self}, 'click');"
    end

    # If called with a block it will attach the block to the "click" event of the marker.
    # If +info_window_options+ are supplied an info window will be opened with those options and the block will be ignored.
    #
    # ==== Example:
    #
    #  # Open a info window and circle the marker.
    #  marker.click do |script|
    #    marker.open_info_window :url => {:controller => :spot, :action => :show, :id => @spot}
    #    marker.circle!
    #  end
    def click(info_window_options = nil, &block) # :yields: script
      if info_window_options
        self.click do
          self.open_info_window info_window_options
        end
      elsif block_given?
        self.listen_to :event => :click, &block
      end
    end

    # This event is fired when the marker is "picked up" at the beginning of being dragged.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.    
    def when_picked_up(&block)
      self.listen_to :event => :dragstart, &block
    end

    # This event is fired when the marker is being "dragged" across the map.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +current_location+ - The location at which the marker is presently hovering.
    def when_being_dragged
      self.listen_to :event => :drag do
        script << "current_location = #{self.var}.getLatLng();"

        yield script, :current_location
      end
    end

    # This event is fired when the marker is "dropped" after being dragged.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +drop_location+ - The location on the map where the marker was dropped.
    def when_dropped
      self.listen_to :event => :dragend do |script|          
        script << "drop_location = #{self.var}.getLatLng();"

        yield script, :drop_location
      end
    end
   
    # Opens an info window that contains a blown-up view of the map around this marker.
    #
    # ==== Options:
    # * +zoom_level+ - Optional. Sets the blowup to a particular zoom level.
    # * +map_type+ - Optional. Set the type of map shown in the blowup.
    def show_map_blowup(options = {})
     options[:map_type] = options[:map_type].to_map_type if options[:map_type]

     self << "#{self.var}.showMapBlowup(#{options.to_google_options});" 
    end
    
    # Changes the foreground icon of the marker to the given +image+. Note neither the print image nor the shadow image are adjusted.
    #
    #  marker.change_icon :green_cicle #=> "/images/green_circle.png"
    #  marker.change_icon "/images/red_dot.gif"
    def change_icon(image)
      image = Google::OptionsHelper.to_image(image)

      self << "#{self.var}.setImage(#{image.to_js});"
    end

    # Draws a circle around the marker, see Circle#new for valid styling options.
    #
    # ==== Examples:
    #  marker.circle!
    #
    #  marker.circle! :radius => 500, :border_width => 5
    def circle!(options = {})
      options[:var] = self.circle_var
      options[:location] = self.location

      @circle = Google::Circle.new options
      if self.draggable?
        self.when_being_dragged do |script, current_location|
          @circle.move_to current_location
        end
      end

      @circle
    end
    
    def circled? # :nodoc:
      @circle.not_nil?
    end

    # See Tooltipable#set_tooltip about valid +options+
    def set_tooltip(options)
      super
      
      if self.draggable?
        self.when_picked_up do |script|
          self.tooltip.marker_picked_up
        end

        self.when_dropped do |script, location|
          self.tooltip.marker_dropped
        end

        self.when_being_dragged do
          self.tooltip.force_redraw
        end
      end
    end
            
    def draggable=(value) # :nodoc:
      @draggable = value

      if self.draggable?
        self.when_picked_up{ self.close_info_window }
      end
    end

    def draggable? # :nodoc:
      @draggable
    end
    
    # This event is fired when the mouse "moves over" the marker.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_over(&block)
      self.listen_to :event => :mouseover, &block
    end

    # This event is fired when the mouse "moves off" the marker.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def mouse_off(&block)
      self.listen_to :event => :mouseout, &block
    end

    # Moves the marker to the given +location+ on the map.
    def move_to(location)
      location = Google::OptionsHelper.to_location(location)

      self.lat_lng = location

      self.tooltip.force_redraw if self.tooltip
      self.circle.move_to(location) if self.circled?
    end
    
    def added_to_map(map) # :nodoc:
      self.add_tooltip_to_map(map)
    end
    
    def removed_from_map(map) # :nodoc:
      self.close_info_window
      self.remove_tooltip_from_map(map)

      self.script.if "typeof(#{self.circle_var}) != 'undefined'" do               
        map.remove_overlay self.circle_var
      end
    end   
  
  end
end