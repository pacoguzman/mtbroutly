ENV["RAILS_ENV"] ||= "test"

# Sets up the Rails environment for Cucumber
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'cucumber/rails/world'

require 'cucumber/formatters/unicode'  # Comment out this line if you don't want Cucumber Unicode support
# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'
Webrat.configure do |config|
  config.mode = :rails
end

require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/../../spec/factories')

require 'mundo_pepino'

MundoPepino::ModelsToClean = [
  Waypoint, # (TODO: quitar la coma final si es el primer modelo)
  Route, # (TODO: quitar la coma final si es el primer modelo)
  User
  # MODELOS PARA LIMPIAR antes de cada escenario,
  # por ejemplo:
  # Orchard, Terrace, Crop...
]


