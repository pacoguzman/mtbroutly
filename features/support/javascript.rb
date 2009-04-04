# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "selenium"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
#Cucumber::Rails.use_transactional_fixtures # Turn off
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'

Webrat.configure do |config|
  config.mode = :selenium
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

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

Before do
  MundoPepino::ModelsToClean.each { |model| model.destroy_all }
end