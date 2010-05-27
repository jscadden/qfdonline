Cucumber::Rails::World.use_transactional_fixtures = false

Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  config.application_environment = "cucumber"
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

Before do
  Rails.logger.debug("Cleaning database")
  # truncate your tables here, since you can't use transactional fixtures*
  DatabaseCleaner.clean
end

class ActiveSupport::TestCase
  setup do |session|
    session.host! "localhost:3001"
  end
end

require 'declarative_authorization/maintenance'
World(Authorization::TestHelper)
