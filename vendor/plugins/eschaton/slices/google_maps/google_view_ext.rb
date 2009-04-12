# All methods noted here become available on all rails views and provide helpers relating to google maps.
module GoogleViewExt

  # Works in the same way as run_javascript but code is treated as google map script.
  #
  #  run_map_script do |script|
  #    map = Google::Map.new(:controls => [:small_map, :map_type],
  #                          :center => {:latitude => -33.947, :longitude => 18.462})
  #  end
  def run_map_script(&block)
    run_javascript do |script|
      script.google_map_script {yield script}
    end
  end

  # Includes the required google maps and eschaton javascript files. This must be called in the view or layout 
  # to enable google maps functionality.
  #
  # ==== Options:
  # * +key+ - Optional. See ApiKey.get or supply the key[http://code.google.com/apis/maps/signup.html] as an option.
  # * +include_jquery+ - Optional. Indicates if the jquery file should be included, defaulted to +true+, set this to +false+ if you have already included jQuery.
  def include_google_javascript(options = {})
    options.default! :key => Google::ApiKey.get(:domain => request.domain), :include_jquery => true

    options.assert_valid_keys :key, :include_jquery

    jquery_script = self.include_jquery_javascript if options[:include_jquery] == true
    google_script = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{options[:key]}\" type=\"text/javascript\"></script>"

    collect google_script, jquery_script,
            javascript_include_tag('eschaton')
  end
    
  # Creates a google map div with the given +options+, this is used in the view to display the map.
  #
  # ==== Options:
  # * +id+ - Optional. The id of the map the default being +map+
  # * +fullscreen+ - Optional. A value indicating if the map should be fullscreen and take up all the space in the browser window.
  # * +width+ - Optional. The width of the map in pixels.
  # * +height+ - Optional. The height of the map in pixels.
  # * +style+ - Optional. Extra style attributes to be added to the map provided as standard CSS.
  #
  # ==== Examples:
  #   google_map :fullscreen => true
  #   google_map :width => 600, :height => 650
  #   google_map :width => 600, :height => 650, :style => 'border: 1px dashed black; margin: 10px'
  #   google_map :id => 'my_cool_map'
  def google_map(options = {})
    options.assert_valid_keys :id, :fullscreen, :width, :height, :style
    
    options[:id] ||= 'map'
    
    map_style = options[:style] || ""
    
    if options.extract(:fullscreen)
      map_style << "position: absolute; top: 0; left: 0;
                    height: 100%; width: 100%;
                    overflow: hidden;"
    else
      map_style << "width: #{map_size(options.extract(:width))};" if options[:width]
      map_style << "height: #{map_size(options.extract(:height))};" if options[:height]
    end
    
    options[:style] = map_style
    
    content_tag :div, 'loading map...', options
  end
  
  # Works in much the same as link_to_function but allows for mapping script to be written within the script block
  #
  #  link_to_map_script("Show info") do |script|
  #    script.map.open_info_window :text => 'I am showing some info'
  #  end
  def link_to_map_script(name, *args, &block)
    link_to_function name, *args do |script|
      Eschaton.with_global_script(script) do
        script.with_mapping_scripts do
          yield script

          script << Google::Scripts.extract(:end_of_map_script)
        end
      end
    end
  end

  # Unless the +condition+ is +true+ this will have the same effect as link_to_map_script otherwise
  # +name+ will be returned.
  def link_to_map_script_unless(condition, name, *args, &block)
    unless condition
      link_to_map_script name, *args, &block
    else
      name
    end
  end
  
  # Works in exactly the same way as rails +form_remote_tag+ but provides some extra options. This would be used 
  # to create a remote form tag within an info window.
  #
  # ==== Options:
  # * +include_location+ - Optional. Indicates if latitude and longitude +params+(if present) should be include in the +url+, defaulted to +true+.
  def info_window_form(options, &block) #TODO rename => info_window_form_tag
    prepare_info_window_options(options)
    
    form_remote_tag options, &block
  end

  def info_window_form_for(model, model_instance, options, &block)
    prepare_info_window_options(options)
    
    remote_form_for model, model_instance, options, &block
  end

  def prepare_info_window_options(options)
    options.default! :include_location => true, :html => {}

    include_location = options.extract(:include_location)
    if include_location && params[:location].not_blank?
      options[:url][:location] = params[:location]
    end

    options[:html][:class] = :info_window_form
  end
  
  # A 'cancel' link that will close the currently open info window on the map.
  # Useful when writing forms in info windows.
  def cancel_info_window_link
    link_to_map_script 'cancel' do |script|
      script.map.close_info_window
    end
  end  
  
  private
    def map_size(size)
      if size.is_a?(Numeric)
        "#{size}px"
      else
        size
      end
    end
  
end