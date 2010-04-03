Given /^I\'m on the new primary requirement form$/ do
  visit(new_hoq_primary_requirement_path(@hoq))
end

Then /^I should see a primary requirement "([^\"]*)"$/ do |name|
  response.should have_tag("div.cell", /#{name}/)
end

Given /^I\'m on the new secondary requirement form$/ do
  visit(new_hoq_secondary_requirement_path(@hoq))
end

Then /^I should see a secondary requirement "([^\"]*)"$/ do |name|
  response.should have_tag("div.cell", /#{name}/)
end
