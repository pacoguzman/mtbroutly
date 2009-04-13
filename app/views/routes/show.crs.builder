xml.instruct!
# Plantilla tomada de un ejemplo de ruta de Wikiloc
#PENDING
xml.TrainingCenterDatabase("xsi:schemaLocation" => "http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v1 http://www.garmin.com/xmlschemas/TrainingCenterDatabasev1.xsd",
  "xmlns" => "http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v1", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do
  xml.tag! "Courses" do
    xml.tag! "CoursesFolder", "Name" => "Courses" do
      xml.tag! "Course" do
        xml.Name @route.title
        xml.tag! "Track" do
          @route.waypoints.each do |way|
            xml.tag! "Trackpoint"  do
              #TODO create at_time attribute for routes
              xml.Time "0.000000"
              xml.Position do
                xml.LatitudDegrees way.lat.to_s
                xml.LongitudeDegrees way.lng.to_s
              end
              xml.AltitudMeters way.alt.to_s
            end
          end
        end
      end
    end
  end
end

