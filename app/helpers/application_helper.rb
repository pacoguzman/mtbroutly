# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_ajax_messages(message = {})
    content_tag(:div, :id => "ajax_messages" ) do
      message.collect{|entry|
        content_tag(:div, entry[1], :class => "notice #{entry[0]}")
      }
    end
  end

  def you_or_user_login(user)
    current_user == user ? "you" : user.login
  end

  #Genera el código javascript necesario para el rating
  def javascript_rating(rated, rating = {})
    js = ""
    js << "new Starbox('rating_total', #{rated.total_rate_average}, { className: 'dotted', stars: 5, buttons: 25, locked: true });"
    rated.class.options[:dimensions].each do |dimension|
      js << "new Starbox('rating_total_#{dimension}', #{rated.rate_average(false, dimension)}, { className: 'dotted', stars: 5, buttons: 25, locked: true });"
      js <<  "/*new Control.Modal('rating_help_link_#{dimension.to_s}',{"
      js <<  "hover: true,"
      js <<  "opacity: 0.8,"
      js <<  "position: 'relative',"
      js <<  "containerClassName: 'ratings',"
      js <<  "width: 250,"
      js <<  "offsetLeft: 20,"
      js <<  "height: 15"
      js <<  "});*/"
    end

    #Se pinta lo que paso el usuario cambiar el 0 por el valor que pinto
    rated.class.options[:dimensions].each do |dimension|
      user_rating = rating.include?(dimension) ? rating[dimension] : 0
      js <<  "new Starbox('rating_user_#{dimension}', #{user_rating}, { rated: true, className: 'dotted', stars: 5, buttons: 10, rerate: true, onRate: function(element, info){$('rating_#{dimension}').value = info.rated} });"
      js <<  "/*new Control.Modal('rating_help_link_#{dimension}',{"
      js <<  "hover: true,"
      js <<  "opacity: 0.8,"
      js <<  "position: 'relative',"
      js <<  "containerClassName: 'ratings',"
      js <<  "width: 250,"
      js <<  "offsetLeft: 20,"
      js <<  "height: 15"
      js <<  "});*/"
    end
    js
  end
end
