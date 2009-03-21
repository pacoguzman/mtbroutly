xml.instruct!
# Plantilla tomada de un ejemplo de ruta de Wikiloc
# Definir GPX_NS global com "http://www.topografix.com/GPX/1/1"
#PENDING
xml.gpx("creator" => "MTBRoutes - http://", "version" => "1.1", "xmlns" => "http://www.topografix.com/GPX/1/1") do
  xml.tag! "trk" do
    xml.name @route.name
    xml.cmt @route.name
    xml.desc @route.description
    xml.tag! "trkseg" do
      @route.locations.each do |loc|
        xml.tag! "trkpt", "lat" => loc.lat.to_s , "lon" => loc.lng.to_s  do
          xml.ele "0.000000"
        end
      end
    end
  end
end
