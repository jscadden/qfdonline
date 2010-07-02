Given /^a collab_test user exists$/ do
  collab_test_user = Factory("collab_test_user")
  invitation = Factory("invitation", :recipient => collab_test_user)
  invitation.update_attributes(:recipient => collab_test_user)
end

When /^I change the name of a requirement to "([^\"]*)"$/ do |name|
  qfd = Invitation.accepted.first.qfd
  req = qfd.hoqs.first.primary_requirements.first
  double_click(".cell.name.requirement_#{req.id}")

  sleep 1 # let the js do its thing

  elem = page.driver.browser.find_element(:xpath, "//input[@name='requirement[name]']")
  elem.send_keys(name)
  elem.send_keys(:enter)

  sleep 1 # let the requirement be updated
end

Then /^I should see the name of a requirement is "([^\"]*)"$/ do |name|
  Then "the new HOQ should have a primary requirement \"#{name}\""
end

Given /^my invitations are all read\-only$/ do
  Invitation.all.each {|i| i.update_attribute(:read_only, true)}
end

Then /^I should see no requirements named "([^\"]+)"$/ do |name|
  page.should_not have_content(name)
end

When /^I double click on the name of a requirement$/ do
  qfd = Invitation.accepted.first.qfd
  req = qfd.hoqs.first.primary_requirements.first
  double_click(".cell.name.requirement_#{req.id}")
  sleep 1
end

Then /^I should not be presented with an input$/ do
  page.should_not have_css("input[name='requirement[name]']")
end

Given /^I can collaborate (read\-only )?on a QFD named "([^\"]*)"$/ do |ro, name|
  user = User.find_by_email("test_user1@qfdonline.com") || Factory("user")
  Factory("invitation", 
          :sender => user,
          :read_only => ro ? true : false,
          :recipient => Authorization::current_user, 
          :qfd => Factory("qfd", :name => name, :user => user))
end

Then /^I should see a link to "([^\"]*)" with "([^\"]*)" permissions$/ do |link_text, permissions|
  page.should have_css("a", :text => link_text)
  page.should have_content(permissions)
end
