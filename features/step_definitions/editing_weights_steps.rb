Given /^a editing_weights_test user exists$/ do
  user = Factory.create("editing_weights_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I double click on the first primary requirement\'s weight cell$/ do
  double_click(".weight.first_hoq")
end

Then /^I should see "([^\"]*)" in the first primary requirement\'s weight cell$/ do |value|
  page.should have_xpath("//*[contains(@class, 'row') and (position() > 3)]//*[contains(@class, 'weight') and (contains(@class, 'first_hoq'))]//span[contains(@class, 'value')]", :text => /#{value}/)
end

When /^I type "([^\"]*)"$/ do |value|
  if /(.*)\\n/ === value
    value = $~[1]
    press_enter = true
  end

  elem = page.driver.browser.find_element(:xpath, "//input[@name='requirement[weight]']")
  elem.send_keys(value)
  elem.send_keys(:enter) if press_enter
end

