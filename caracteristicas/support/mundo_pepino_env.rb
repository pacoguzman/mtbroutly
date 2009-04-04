# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

require 'webrat/rails'

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'

require 'mundo_pepino'

Webrat.configure do |config|
  config.mode = :rails
end

MundoPepino::ModelsToClean = [
  Waypoint, # (TODO: quitar la coma final si es el primer modelo)
  Route, # (TODO: quitar la coma final si es el primer modelo)
  User
  # MODELOS PARA LIMPIAR antes de cada escenario,
  # por ejemplo:
  # Orchard, Terrace, Crop...
]

String.model_mappings = {
  /^waypoints?$/i => Waypoint, # (TODO: validar RegExp para forma plural y coma final)
  /^rutas?$/i => Route, # (TODO: validar RegExp para forma plural y coma final)
  /^usuari(o|a)s?$/i => User
  # TRADUCCIÓN DE MODELOS AQUÍ, por ejemplo:
  # /^huert[oa]s?/i            => Orchard,
  # /^bancal(es)?$/i           => Terrace,
  # /^cultivos?$/i             => Crop...
}

String.field_mappings = {
  /^altitud(es)?$/i => :alt, # (TODO: validar RegExp para forma plural y coma final)
  /^posici[o|ó]n(es)?$/i => :position, # (TODO: validar RegExp para forma plural y coma final)
  /^longitud(es)?$/i => :lng, # (TODO: validar RegExp para forma plural y coma final)
  /^latitud(es)?$/i => :lat, # (TODO: validar RegExp para forma plural y coma final)
  /^direcci[o|ó]n(es)?$/i => :address, # (TODO: validar RegExp para forma plural y coma final)
  /^Route::nombre$/i => :title, # (TODO: validar RegExp para forma plural y coma final)
  #/^distancias?$/i => :distance,
  /^descripci[o|ó]n(es)?$/i => :description, # (TODO: validar RegExp para forma plural y coma final)
  /^User::nombre$/i => :login,
  /^password$/i => :password,
  /^conf_password$/i => :password_confirmation,
  /^correo$/i => :email
  # TRADUCCIÓN DE CAMPOS AQUÍ:
  # /^[Ááa]reas?$/i    => 'area',
  # /^color(es)?$/i   => 'color',
  # /^latitud(es)?$/i => 'latitude',
  # /^longitud(es)?/i => 'length'
  #
  # TRADUCCIÓN ESPECÍFICA PARA UN MODELO
  # /^Orchard::longitud(es)?$/   => 'longitude'
}

String.url_mappings = {
  /la (portada|home)$/i => '/',
  /cerrar sesión$/i => '/sessions/delete',
  /listado general de rutas$/ => '/routes',
  /listado general de rutas más nuevas$/ => '/routes/newest',
  /listado general de rutas mejor valoradas$/ => '/routes/highlighted'
}

require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/../../spec/factories')

class MiMundo < MundoPepino
  # Helpers específicos de nuestras features, por ejemplo:
  #include FixtureReplacement # probado!
  # include Machinist # probado!
end

Before do
  MundoPepino::ModelsToClean.each { |model| model.destroy_all }
end

World do
  MiMundo.new
end

