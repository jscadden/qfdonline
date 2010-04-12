Given /^I\'m on the new primary requirement form$/ do
  visit(new_hoq_primary_requirement_path(@hoq))
end

Then /^I should see a primary requirement "([^\"]*)"$/ do |name|
  response.body.should have_tag("div.cell", /#{name}/)
end
