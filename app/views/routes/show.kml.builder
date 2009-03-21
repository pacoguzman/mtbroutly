xml.instruct!
# Definir KML_NS global com "http://www.opengis.net/kml/2.2"
xml.kml("xmlns" => "http://www.opengis.net/kml/2.2") do
  xml.tag! "Document" do
    xml.tag! "Style", :id => "myStartStyle" do
      xml.tag! "BalloonStyle" do
        xml.bgColor "ff00ff00" #format is aabbggrr
      end
    end
    xml.tag! "Style", :id => "myEndStyle" do
      xml.tag! "BalloonStyle" do
        xml.bgColor "ff0000ff" #format is aabbggrr
      end
    end
    xml.tag! "Style", :id => "myPathStyle" do
      xml.tag! "LineStyle" do
        xml.color "7fff0000" #format is aabbggrr
        xml.width "4"
      end
    end
    xml.tag! "Placemark" do
      xml.description @route.description
      xml.name "Start Point"
      xml.styleUrl "#myStartStyle"
      xml.tag! "Point" do
        xml.coordinates @route.locations.first.coordinates
      end
    end
    xml.tag! "Placemark" do
      xml.description @route.description
      xml.name "End Point"
      xml.styleUrl "#myEndStyle"
      xml.tag! "Point" do
        xml.coordinates @route.locations[@route.locations.size - 1].coordinates
      end
    end
    xml.tag! "Placemark" do
      xml.name "Route path"
      xml.styleUrl "#myPathStyle"
      xml.tag! "LineString" do
        xml.extrude
        xml.tessellate
        xml.coordinates @route.coordinates
      end
    end
  end
end
