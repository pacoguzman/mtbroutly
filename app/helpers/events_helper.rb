module EventsHelper


  def init_event_map_form_for(event, options = {})
    run_map_script do
      map = Google::Map.new(:controls => [:large_map_3D, :map_type],
        :center => :best_fit)

      map.enable_scroll_wheel_zoom!
      map.disable_double_click_zoom!
      map.enable_google_bar!

      # A draggable marker that talks when its being dragged and dropped
      marker = map.add_marker :location => {:latitude => -33.947, :longitude => 18.462},
        :tooltip => {:text => "Drag me", :show => :always},
        :draggable => true

      marker.when_being_dragged do
        marker.update_tooltip :text => "Dragging..."
      end

      marker.when_dropped do |script, drop_location|
        marker.update_tooltip :text => "Dropped..."
        marker.open_info_window :text => "Yes, I was getting tired of flying..."
      end


      obj = Eschaton::JavascriptObject.new
      obj << ''
    end
  end
end
