AfterConfiguration do |config|
  if config.options[:tag_expressions].include?("@javascript")
    ENV["javascript"] = "1"

    DatabaseCleaner.strategy = :truncation

    Cucumber::Rails::World.use_transactional_fixtures = false

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
  end
end

Before do
  if "1" == ENV["javascript"]
    DatabaseCleaner.clean
  end
end

