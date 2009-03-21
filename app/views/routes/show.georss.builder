xml.instruct!
# Definir GEORSS_NS global com "http://www.georss.org/georss"
xml.rss(:version => "2.0", "xmlns:georss" => "http://www.georss.org/georss") do
  xml.channel do
    xml.title "Demo feed for RailsConf Europe 2007"
    xml.link( locations_url )
    xml.description "This is only a demo no big deal!"
    xml.pubDate(@route.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
    @recent_routes.each do |route|
       xml.item do
         xml.title route.name
         xml.link( route_url(route) )
         xml.description route.description
         xml.point route.locations.first.coordinates
       end
    end
  end
end
