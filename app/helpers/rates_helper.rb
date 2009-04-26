module RatesHelper
  
  def javascript_rating(rated, rating = {})

    js = build_js_starbox('rating_total', nil, stars = rated.total_rate_average, :total => true)
    rated.class.options[:dimensions].each do |dimension|
      js << build_js_starbox("rating_total_", dimension, stars = rated.rate_average(false, dimension), :total => true)
      js << build_js_modal(dimension)
    end

    rated.class.options[:dimensions].each do |dimension|
      user_stars = rating.include?(dimension) ? rating[dimension] : 0
      js << build_js_starbox("rating_user_", dimension, user_stars)
      js << build_js_modal(dimension)
    end
    js
  end

  def build_js_starbox(base_id, dimension, stars, options = {})
    if options[:total] == true
      "new Starbox('#{base_id}#{dimension}', #{stars}, { className: 'dotted', stars: 5, buttons: 25, locked: true });"
    else # user
      "new Starbox('#{base_id}#{dimension}', #{stars}, { rated: true, className: 'dotted', stars: 5, buttons: 10, rerate: true, onRate: function(element, info){$('rating_#{dimension}').value = info.rated} });"
    end
  end

  def build_js_modal(dimension)
    js =  "/*new Control.Modal('rating_help_link_#{dimension}',{"
    js <<  "hover: true,"
    js <<  "opacity: 0.8,"
    js <<  "position: 'relative',"
    js <<  "containerClassName: 'ratings',"
    js <<  "width: 250,"
    js <<  "offsetLeft: 20,"
    js <<  "height: 15"
    js <<  "});*/"
    js << "\n"
    js
  end

end

