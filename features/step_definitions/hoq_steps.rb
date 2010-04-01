Given /^I\'m on the new HOQ form$/ do
  visit(new_qfd_hoq_path(@qfd))
end

Given /^I\'ve created a HOQ$/ do
  @hoq = Factory.build("hoq")
  @qfd.hoq_list.insert_back(@hoq)
end

Given /^I\'ve added a secondary requirement "([^\"]*)" to the HOQ$/ do |name|
  visit(new_hoq_secondary_requirement_path(@hoq))
  fill_in "Name", :with => name
  click_button "Create Secondary Requirement"
end

When /^I create a new HOQ$/ do
  visit(new_qfd_hoq_path(@qfd))
  fill_in "Name", :with => "2nd HOQ"
  click_button "Create HOQ"
end

Then /^the new HOQ should have a primary requirement "([^\"]*)"$/ do |name|
  response.should have_tag(".requirements.primary li", /#{name}/)
end
