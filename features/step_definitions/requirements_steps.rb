Then /^I should see the requirement\'s name$/ do
  response.should contain(@requirement.name)
end

Then /^a link to the requirement$/ do
  response.should have_tag("a[href=\"#{requirement_path(@requirement)}\"]")
end
