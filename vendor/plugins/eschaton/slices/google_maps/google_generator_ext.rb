module GoogleGeneratorExt
  
  def with_mapping_scripts
    self << Google::Scripts.before_map_script
    
    yield self
    
    self << Google::Scripts.after_map_script
    
    Google::Scripts.clear :before_map_script, :after_map_script
  end
  
  # Any script that is added within the block will execute if the browser is compatible with google maps 
  # and when the document is ready.
  def google_map_script
    self.with_mapping_scripts do
      self.when_document_ready do      
        self << "window.onunload = GUnload;"
        self << "if (GBrowserIsCompatible()) {"

        yield self

        self << Google::Scripts.extract(:end_of_map_script)

        self << "} else { alert('Your browser be old, it cannot run google maps!');}"
      end
    end
  end

  # Used when working on google map objects in RJS templates.
  #
  # RJS template:
  #   page.alert("before mapping")
  #
  #   page.mapping_script do
  #     marker = page.map.add_marker :location => {:latitude => 33.4, :longitude => 18.5}
  #     marker.click {page.alert("marker clicked!")}
  #   end
  #
  #   page.alert("after mapping")
  #
  # ==== Options:
  # * +run_when_doc_ready+ - Optional, indicates is code should be wrapped in google_map_script.
  def mapping_script(options = {}, &block)
    options.default! :run_when_doc_ready => true

    Eschaton.with_global_script(self) do
      if options[:run_when_doc_ready]
        self.google_map_script &block
      else
        self.with_mapping_scripts do
          yield self
          self << Google::Scripts.extract(:end_of_map_script)
        end
      end
    end
  end
  
  # Sets latitude and longitude values of the +location+ option in html input elements.
  # Used to update form fields with a location on the map such as click location or the location of a marker.
  #
  # ==== Options
  # * +location+ - Required. The location whos latitude and logitude will be used.
  # * +latitude_element+ - Optional. The id of the element whos value will be set to the latitude of the +location+ option. Defaulted to id of +latitude+.
  # * +longitude_element+ - Optional. The id of the element whos value will be set to the longitude of the +location+ option. Defaulted to id of +longitude+.
  #
  # ==== Examples:
  #
  # Say we wanted to set the click location of the map to html input elements:
  #
  #  # The two elements
  #  <input type="text" name="latitude" value="" id="latitude">
  #  <input type="text" name="longitude" value="" id="longitude">
  #
  #  # The code
  #  map.click do |script, location|
  #    script.set_coordinate_elements :location => location
  #  end
  #
  # Or, set the values of specific elements using a markers location
  #
  #  # The two elements
  #  <input type="text" name="location[latitude]" value="" id="location_latitude">
  #  <input type="text" name="location[latitude]" value="" id="location_longitude">
  #
  #  # The code 
  #  marker = map.add_marker ...
  #  map.click do |script, location|
  #    script.set_coordinate_elements :location => marker.location,
  #                                   :latitude_element => :location_latitude
  #                                   :longitude_element => :location_longitude                                      
  #  end
  def set_coordinate_elements(options = {})
    options.default! :latitude_element => :latitude, :longitude_element => :longitude
    location = options[:location]
    
    self << "$('#{options[:latitude_element]}').value = #{location}.lat();"
    self << "$('#{options[:longitude_element]}').value = #{location}.lng();"
  end  

end