Given /^I\'ve created a HOQ$/ do
  visit(new_qfd_hoq_path(latest_qfd))
  fill_in("Name", :with => "2nd Test HOQ")
  click_button("Create HOQ")
end

Given /^I\'ve added a secondary requirement "([^\"]*)" to the HOQ$/ do |name|
  When "I right click on the column #1's number cell"
  When "I click on \"Insert After\" in the column menu"
  When "I rename the new requirement to \"#{name}\""
end

When /^I create a new HOQ$/ do
  visit(new_qfd_hoq_path(latest_qfd))
  fill_in "Name", :with => "2nd HOQ"
  click_button "Create HOQ"
end

Then /^the new HOQ should have a primary requirement "([^\"]*)"$/ do |name|
  page.should have_css("div.cell.name", :text => name)
end

Then /^I should see the new HOQ\'s title$/ do 
  page.should have_css("h1", :text => "2nd HOQ")
end

When /^I rename the new requirement to "([^\"]+)"$/ do |name|
  sleep 2 # let the requirement be created
  req_id = latest_requirement.id
  double_click(".cell.name.requirement_#{req_id}")
  sleep 2 # let the js do its thing
  elem = page.driver.browser.find_element(:xpath, "//input[@name='requirement[name]']")
  elem.send_keys(name)
  elem.send_keys(:enter)
  sleep 2 # let the requirement be updated
end
