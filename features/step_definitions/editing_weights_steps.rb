Given /^a editing_weights_test user exists$/ do
  user = Factory.create("editing_weights_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I double click on the first primary requirement\'s weight cell$/ do
  selenium.double_click("css=.weight.first_hoq")
end

Then /^I should see "([^\"]*)" in the first primary requirement\'s weight cell$/ do |value|
  selenium.get_text("xpath=//*[contains(@class, 'row') and (position() > 3)]//*[contains(@class, 'weight') and (contains(@class, 'first_hoq'))]//span[contains(@class, 'value')]").should match(/\s*#{value}\s*/)
end

When /^I type "([^\"]*)"$/ do |value|
  selenium.type("xpath=//input", value)
  selenium.fire_event("xpath=//input", "change")
  #selenium.submit("xpath=//form")
end
