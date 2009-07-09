module ProfilesHelper

   def init_profile_map_for(profile, options = {})
    options.reverse_merge!(:mode => "show")
    run_map_script do
      # Obtain the center
      if profile.waypoint.new_record?
        center = center_from_client_location(options[:client_location])
      else
        center = profile.waypoint.vertice
      end
      # Obtain the gravatar
      if profile.icon?
        gravatar_tag = icon_for_profile(profile, 'small')
      else
        # Trying with gravatar
        gravatar_tag = image_tag(Gravatar.image_url(:email_address => @profile.user.email), :alt => "Gravatar uer image", :name => profile.full_name)
      end


      map = Google::Map.new(:controls => [:large_map_3D, :map_type],
        :center => center, :zoom => 8)

      map.enable_scroll_wheel_zoom!
      map.disable_double_click_zoom!
      map.enable_google_bar!

      if center != :best_fit
         marker = Google::Marker.new :location => center, :icon => "/images/map/markers/green.png" ,
           :draggable => true 
         
         marker.click do |script|
           marker.open_info_window :partial => "/shared/profile_info_window", :locals => {:text => "Hello there...", :gravatar_tag => gravatar_tag}
         end
         
         marker.when_dropped do |script, drop_location|
           script.set_coordinate_elements :location => drop_location,
                                  :latitude_element => "profile_waypoint_lat",
                                  :longitude_element => "profile_waypoint_lng"
           marker.open_info_window :partial => "shared/profile_info_window", :locals => {:text => "Yes, I was getting tired of flying...", :gravatar_tag => gravatar_tag}
         end

      else
        center = map.center
        marker = Google::Marker.new :location => center,
                    :gravatar => profile.user.email, :draggable => true
      end

       map.add_marker(marker)
    end
  end
end
