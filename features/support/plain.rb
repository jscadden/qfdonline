# Since we're not using selenium, we want to have transactional fixtures
Cucumber::Rails::World.use_transactional_fixtures = true
