# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'desert'
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  #config.gem 'ffmike-db_populate', :version => '0.2.3', :source => 'http://gems.github.com'
  config.gem 'searchlogic', :version => '1.6.6', :source => 'http://gems.github.com'
  config.gem 'geokit', :version => '>=1.4.1', :source => 'http://gems.github.com'
  config.gem 'tog-tog', :lib => 'tog', :version => '0.5.3'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com', :version => '~> 2.3.6'
  config.gem 'desert', :lib => 'desert', :version => '0.5'
  config.gem 'crack', :version => '>=0.1.2', :source => 'http://gems.github.com'
  config.gem "RedCloth", :lib => "redcloth", :source => "http://code.whytheluckystiff.net"

  #TODO use tog_conclave
  ## Tog Conclave gems
  #config.gem 'google-geocode', :version => '~> 1.2.1', :lib => 'google_geocode'

  # Possibly utils gems
  #config.gem 'settinglogic' #url -> http://github.com/binarylogic/settingslogic

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  config.plugins = [:acts_as_abusable, :acts_as_commentable, :acts_as_favoriteable,
    :acts_as_rateable, :acts_as_scribe, :acts_as_state_machine, :acts_as_taggable_on_steroids,
    :"ajaxful-rating", :eschaton, :fixture_replacement2, :"geokit-rails", :later_dude,
    :meta_tags, :"mundo-pepino", :paperclip, :query_reviewer, :seo_urls, :"string-mapper",
    :cucumber_rails_debug,
    #:tog_conclave,
    :tog_core, :tog_mail, :tog_social, :tog_user, :viking
    #:"ym4r-gm"
  ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  Dir[File.dirname(__FILE__) + '/locales/**/*.yml'].each do |file|
    config.i18n.load_path << file
  end
  #config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'config', 'locales', '*.{rb,yml}')]
  #config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_mtbroutly_session',
    :secret      => '59359f7e9c1a081ba686ae0a84d38b3ab2761c8356dc28e7ac045bf3fde1cf433b56aa856405d976bbcfb483e914c349105ddc6751ce3a64b96a1416baa4c431'
  }

end
