Given /^I\'m on the new QFD form$/ do
  visit(new_qfd_path)
end

Given /^I\'ve created a QFD$/ do
  without_access_control do
    @qfd = User.first.qfds.create!(:name => "Test QFD")
  end
end

Given /^I\'m viewing the QFD$/ do
  visit(qfd_path(@qfd))
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
  without_access_control do
    Factory("qfd", :public => true, :name => name)
  end
end

When /^I visit the QFD named "([^\"]*)"$/ do |name|
  qfd = Qfd.find_by_name(name)
  visit(qfd_path(qfd))
end
