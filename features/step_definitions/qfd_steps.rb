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
