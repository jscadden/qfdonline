DatabaseCleaner.strategy = :truncation

Cucumber::Rails::World.use_transactional_fixtures = false

Before do
  DatabaseCleaner.clean
end

pidfile = Rails.root + "tmp/pids/Xvfb.pid"
if ENV["NOXVFB"].blank?
  `start-stop-daemon --start --pidfile #{pidfile} -m -b --exec /usr/bin/Xvfb -- -ac -screen scrn 1024x768x24 :2.0`
  ENV["DISPLAY"] = ":2.0"
end

at_exit do
  if ENV["NOXVFB"].blank?
    `start-stop-daemon --stop --pidfile #{pidfile}`
  end
end

require 'declarative_authorization/maintenance'
World(Authorization::TestHelper)
