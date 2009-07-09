## see http://wiki.github.com/aslakhellesoy/cucumber/setting-up-selenium for help
#require 'spec/expectations'
#require 'selenium'
#require 'webrat'
#
#Webrat.configure do |config|
#  config.mode = :selenium
#  # Selenium defaults to using the selenium environment. Use the following to override this.
#  #config.application_environment = :test
#end
#
#require 'database_cleaner'
#DatabaseCleaner.strategy = :truncation
#
#Before do
#  # truncating the database tables here, since transactional fixtures
#  # can not be used with selenium
#  DatabaseCleaner.clean
#end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false
end 

Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  # config.application_environment = :test
  config.application_environment = :test
  config.application_framework = :rails
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
Before do
  # truncate your tables here, since you can't use transactional fixtures*
  DatabaseCleaner.clean
end


