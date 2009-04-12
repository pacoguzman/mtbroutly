require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class MapTest < Test::Unit::TestCase
  
  def test_map_initialize
    assert_output_fixture :map_default,
                          Eschaton.with_global_script{ 
                            map = Google::Map.new
                          }

    assert_output_fixture :map_with_center, 
                          Eschaton.with_global_script{
                            map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0}
                          }
    
    assert_output_fixture :map_with_args,
                          Eschaton.with_global_script{
                            map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0},
                                                  :controls => [:small_map, :map_type],
                                                  :zoom => 12,
                                                  :type => :satellite
                          }
  end

  def test_add_control
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

        assert_output_fixture 'map.addControl(new GSmallMapControl());', 
                               script.record_for_test {
                                 map.add_control :small_map
                               }

        assert_output_fixture 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(0, 0)));', 
                              script.record_for_test {
                                map.add_control :small_map, :position => {:anchor => :top_right}
                              }

        assert_output_fixture 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(50, 10)));',
                              script.record_for_test {
                                map.add_control :small_map, :position => {:anchor => :top_right, :offset => [50, 10]}
                              }

        assert_output_fixture 'map.addControl(new GSmallMapControl());', 
                               script.record_for_test {
                                 map.controls = :small_map
                               }

        assert_output_fixture :map_controls, 
                               script.record_for_test {
                                 map.controls = :small_map, :map_type
                               }
        # 3D controls                       
        assert_output_fixture 'map.addControl(new GLargeMapControl3D());', 
                               script.record_for_test {
                                 map.add_control :large_map_3D
                               }

        assert_output_fixture 'map.addControl(new GSmallZoomControl3D());', 
                               script.record_for_test {
                                 map.add_control :small_zoom_3D
                               }                               
      end
    end
  end

  def test_open_info_window_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
        # With :url and :include_location params
        assert_output_fixture :map_open_info_window_url_center, 
                              script.record_for_test {
                                map.open_info_window :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_center,
                              script.record_for_test {
                                map.open_info_window :location => :center, 
                                                     :url => {:controller => :location, :action => :create}
                              }


        assert_output_fixture :map_open_info_window_url_existing_location,
                              script.record_for_test {
                                map.open_info_window :location => :existing_location, 
                                                     :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_location,
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :create}
                              }

        assert_output_fixture :map_open_info_window_url_no_location,
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :show, :id => 1},
                                                     :include_location => false
                              }

        assert_output_fixture 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "test output for render" + "</div>");', 
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :partial => 'create'
                              }

        assert_output_fixture 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");',
                              script.record_for_test {
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :text => "Testing text!"
                              }
      end
    end    
  end
  
  def test_update_info_window
    Eschaton.with_global_script do |script|
      script.google_map_script do      
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}    
      
        assert_output_fixture 'map.openInfoWindow(map.getInfoWindow().getPoint(), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");',
                               script.record_for_test {
                                 map.update_info_window :text => "Testing text!"
                               }
      end
    end
  end
  
  def test_click_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462} 

        # without body
        assert_output_fixture :map_click_no_body,
                              script.record_for_test {
                                map.click {}
                              }
    
        # With body
        assert_output_fixture :map_click_with_body, 
                              script.record_for_test {
                                map.click do |script, location|
                                  script.comment "This is some test code!"
                                  script.comment "'#{location}' is where the map was clicked!"
                                  script.alert("Hello from map click!")
                                end
                              }

        # Info window convenience
        assert_output_fixture :map_click_info_window,
                              script.record_for_test {
                                map.click :text => "This is a info window!"
                              }
      end
    end    
  end

  def test_add_marker_output
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
        assert_output_fixture "marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                               map.addOverlay(marker);
                               track_bounds.extend(marker.getLatLng());",
                              script.record_for_test {
                                map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}
                              }

        assert_output_fixture "marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              map.addOverlay(marker_1);
                              track_bounds.extend(marker_1.getLatLng());
                              marker_2 = new GMarker(new GLatLng(-34.947, 19.462), {draggable: false});
                              map.addOverlay(marker_2);
                              track_bounds.extend(marker_2.getLatLng());",
                              script.record_for_test {
                                map.add_markers({:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}},
                                                {:var => :marker_2, :location => {:latitude => -34.947, :longitude => 19.462}})
                              }
      end
    end
  end

  def test_replace_marker_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

      assert_output_fixture "map.removeOverlay(marker);
                             marker.closeInfoWindow();
                             if(typeof(tooltip_marker) != 'undefined'){
                             map.removeOverlay(tooltip_marker);
                             }
                             if(typeof(circle_marker) != 'undefined'){
                             map.removeOverlay(circle_marker);
                             }                            
                             marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             map.addOverlay(marker);
                             track_bounds.extend(marker.getLatLng());",
                            script.record_for_test {
                              map.replace_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}
                            }
    end
  end

  def test_change_marker_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

      assert_output_fixture "map.removeOverlay(create_spot);
                             create_spot.closeInfoWindow();
                             if(typeof(tooltip_create_spot) != 'undefined'){
                             map.removeOverlay(tooltip_create_spot);
                             }
                             if(typeof(circle_create_spot) != 'undefined'){
                             map.removeOverlay(circle_create_spot);
                             }
                             marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             map.addOverlay(marker);
                             track_bounds.extend(marker.getLatLng());",
                            script.record_for_test {
                              map.change_marker :create_spot,
                                                {:var => :marker,
                                                 :location => {:latitude => -33.947, :longitude => 18.462}}
                            }
    end
  end

  def test_add_line
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      line = map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
      
      assert line.is_a?(Google::Line)
    end
  end


  def test_add_circle
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      circle = map.add_circle :location => {:latitude => -33.947, :longitude => 18.462}

      assert circle.is_a?(Google::Circle)
    end
  end


  def test_add_circle_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}

      add_circle_output = 'circle = drawCircle(new GLatLng(-33.947, 18.462), 1.5, 40, null, 2, null, "#0055ff", null);
                           map.addOverlay(circle);'
                           
      assert_output_fixture add_circle_output, 
                            script.record_for_test {
                              map.add_circle Google::Circle.new(:location => {:latitude => -33.947, :longitude => 18.462})
                            }
      
      assert_output_fixture add_circle_output, 
                            script.record_for_test {
                              map.add_circle :location => {:latitude => -33.947, :longitude => 18.462}
                            } 
    end
  end


  def test_add_line_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :map_add_line_with_vertex, 
                            script.record_for_test {
                              map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
                            }
                            
      assert_output_fixture :map_add_line_with_vertices, 
                            script.record_for_test {
                              map.add_line :vertices => [{:latitude => -33.947, :longitude => 18.462},
                                                         {:latitude => -34.0, :longitude => 19.0}]
                            }

      assert_output_fixture :map_add_line_with_from_and_to, 
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0}
                            }

      assert_output_fixture :map_add_line_with_colour,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red'
                            }

      assert_output_fixture :map_add_line_with_colour_and_thickness,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10
                            }

      assert_output_fixture :map_add_line_with_style,
                            script.record_for_test {
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10, :opacity => 0.7
                            }

      markers = [Google::Marker.new(:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}),
                 Google::Marker.new(:var => :marker_2, :location => {:latitude => -34.0, :longitude => 19.0}),
                 Google::Marker.new(:var => :marker_3, :location => {:latitude => -35.0, :longitude => 19.0})]

      assert_output_fixture :map_add_line_between_markers,
                            script.record_for_test {
                              map.add_line :between_markers => markers
                            }

      assert_output_fixture :map_add_line_between_markers_with_style,
                            script.record_for_test {
                              map.add_line :between_markers => markers,
                                           :colour => 'red', :weigth => 10, :opacity => 0.7
                            }                            
    end
  end

  def test_clear_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture 'map.clearOverlays();',
                            script.record_for_test {
                              map.clear
                            }
    end
  end

  def test_show_map_blowup_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      # Default with hash location
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462}
                            }

     # Default with existing_location
     assert_output_fixture 'map.showMapBlowup(existing_location, {});', 
                   script.record_for_test {
                     map.show_blowup :location => :existing_location
                   }
      
      # With :zoom_level
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {zoomLevel: 12});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12
                            }

      # With :map_type
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :map_type => :satellite
                            }

      # With :zoom_level and :map_type
      assert_output_fixture 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP, zoomLevel: 12});', 
                            script.record_for_test {
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12,
                                              :map_type => :satellite
                            }
    end
  end

  def test_remove_type
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture 'map.removeMapType(G_SATELLITE_MAP);', 
                            script.record_for_test {
                              map.remove_type :satellite
                            }

      assert_output_fixture :map_remove_type,
                            script.record_for_test {
                              map.remove_type :normal, :satellite
                            }
   end
  end
  
  def test_best_fit_center
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit

        map.add_marker :var => :marker, :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :var => :marker, :location => {:latitude => -33.5, :longitude => 18.5}      
      end
      
      assert_output_fixture :map_best_fit_center, script      
    end
  end

  def test_best_fit_center_and_zoom
    Eschaton.with_global_script do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit, :zoom => :best_fit

        map.add_marker :var => :marker, :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :var => :marker, :location => {:latitude => -33.5, :longitude => 18.5}
      end

      assert_output_fixture :map_best_fit_center_and_zoom, script
    end
  end

end
