Given /^I\'ve created a HOQ$/ do
  @hoq = Factory.build("hoq")
  @qfd.hoq_list.insert_back(@hoq)
end

Given /^I\'ve added a secondary requirement "([^\"]*)" to the HOQ$/ do |name|
  req = Factory.build("requirement", :name => name)
  @hoq.secondary_requirements_list.requirements << req
end

When /^I create a new HOQ$/ do
  visit(new_qfd_hoq_path(@qfd))
  fill_in "Name", :with => "2nd HOQ"
  click_button "Create HOQ"
end

Then /^the new HOQ should have a primary requirement "([^\"]*)"$/ do |name|
  page.should have_css("div.cell", :text => name)
end

Then /^I should see the new HOQ\'s title$/ do 
  page.should have_css("h1", :text => "2nd HOQ")
end
