Given /^I\'m on the new QFD form$/ do
  visit(new_qfd_path)
end

Given /^I\'ve created a QFD$/ do
  visit(new_qfd_path)
  fill_in("Name", :with => "Test QFD")
  click_button("Create QFD")
  page.should have_css(".flash.notice", :text => /success/)
end

Given /^I\'ve a QFD(?: named "([^\"]+)")?$/ do |name|
  args = {:user => latest_user}
  args.merge!(:name => name) if name.present?
  qfd = Factory("qfd", args)
  fail "Failed to create QFD" unless qfd.valid?
end

Given /^I\'m viewing the QFD$/ do
  qfd = Qfd.find(:first, :order => "updated_at DESC")
  visit(qfd_path(qfd))
end

Then /^I should see the QFD\'s first HOQ\'s name, "([^\"]+)"$/ do |name|
  page.should have_css("h1", :text => name)
end

When /^I mark the QFD as public$/ do
  visit(qfds_path)
  click_link("Edit")
  check("Public")
  click_button("Save QFD")
end

When /^I mark the QFD as private$/ do
  visit(qfds_path)
  click_link("Edit")
  uncheck("Public")
  click_button("Save QFD")
end

Then /^I should see an indicator that the QFD is public$/ do
  page.should have_content("Public")
  page.should have_css("img[title='Public']")
end

Then /^I should not see an indicator that the QFD is public$/ do
  page.should_not have_content("Public")
  page.should_not have_css("img[title='Public']")
end

Given /^a public QFD named "([^\"]*)"$/ do |name|
  Factory("qfd", :public => true, :name => name)
end

When /^I visit the QFD named "([^\"]*)"$/ do |name|
  qfd = Qfd.find_by_name(name)
  visit(qfd_path(qfd))
end

When /^I delete the QFD$/ do
  visit(qfds_path)
  click_link("Delete")
end
