ENV["RAILS_ENV"] ||= "test"

# Sets up the Rails environment for Cucumber
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support

Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'ruby-debug'
require 'cucumber_rails_debug/steps'

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/../../spec/factories')

# Make visible for testing # from fbrp
ApplicationController.send(:public, :logged_in?, :current_user, :authorized?)

