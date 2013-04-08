Then /^I should see a new secondary requirement$/ do
  req_id = wait_for_new_requirement_to_be_created
  page.should have_css(".matrix .row .requirement_#{req_id}",
                       :content => "New Requirement")
end

When /^I mouse over the last column\'s number cell$/ do
  mouse_over(".matrix .row:first-child .num:last-child")
end

Then /^I should see the add secondary requirement arrow$/ do
  page.should have_css("#add_column_arrow")
end

When /^I click the add secondary requirement arrow$/ do
  mouse_click("#add_column_arrow")
end
