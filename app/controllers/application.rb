# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  #  #TODO el meta language en función del lenguaje de la página
  #  #TODO los valores por defecto que hagan referencia al nombre final de la aplicación
  #  meta  :title        => "MTBRoutes",
  #    :description  => "MTBRoutes community",
  #    :keywords     => "mtb, routes, route, mountain bike, bike, bikes",
  #    :author => "Riding to NoWhere",
  #    :language => "en"

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5c2db7b94b53292eadd80538225cd32d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password  

  # Overloading tog_core application controller. Now use assets_packager tasks
  def set_javascripts_and_stylesheets
    @javascripts = %w()
    @stylesheets = %w()
    @feeds = %w()
  end

end
