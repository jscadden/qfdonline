Given /^I\'ve created a primary requirement$/ do
  without_access_control do
    @hoq.primary_requirements_list << Factory.build("requirement")
  end
end

Given /^I\'ve created a secondary requirement$/ do
  without_access_control do
    @hoq.secondary_requirements_list << Factory.build("requirement")
  end
end

When /^I double click on the first rating\'s cell$/ do
  if Webrat.configuration.mode == :selenium
    selenium.double_click("css=.rating")
  end
end

Then /^I should see "([^\"]*)" in the rating\'s cell$/ do |value|
  response.body.should have_tag(".value", /#{value}/)
end

Then /^I should see "([^\"]*)" in the rating\'s row\'s maximum cell$/ do |value|
  if Webrat.configuration.mode == :selenium
    selenium.get_text("xpath=//*[contains(@class, 'row') and (position() > 3)]//*[contains(@class, 'maximum')][1]").should match(/\s*#{value}\s*/)
  end
end

Given /^a ratings_test user exists$/ do
  without_access_control do
    user = Factory.create("ratings_test_user")
    @qfd = user.qfds.first
    @hoq = @qfd.hoqs.first
  end
end
