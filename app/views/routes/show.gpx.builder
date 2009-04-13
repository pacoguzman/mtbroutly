xml.instruct!
# Plantilla tomada de un ejemplo de ruta de Wikiloc
# Definir GPX_NS global com "http://www.topografix.com/GPX/1/1"
#PENDING
xml.gpx("creator" => "MTBRoutly - http://", "version" => "1.1", "xmlns" => "http://www.topografix.com/GPX/1/1") do
  xml.tag! "trk" do
    xml.name @route.title
    xml.cmt @route.title
    xml.desc @route.description
    xml.tag! "trkseg" do
      @route.waypoints.each do |way|
        xml.tag! "trkpt", "lat" => way.lat.to_s , "lon" => way.lng.to_s  do
          xml.ele way.alt.to_s
        end
      end
    end
  end
end
