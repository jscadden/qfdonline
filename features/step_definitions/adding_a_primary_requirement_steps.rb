Then /^I should see a new primary requirement$/ do
  req_id = wait_for_new_requirement_to_be_created
  page.should have_css(".matrix .row:last-child .requirement_#{req_id}",
                       :content => "New Requirement")
end

When /^I mouse over the last row\'s number cell$/ do
  mouse_over(".matrix .row:last-child .cell.num")
end

Then /^I should see the add primary requirement arrow$/ do
  page.should have_css("#add_row_arrow")
end

When /^I click the add primary requirement arrow$/ do
  mouse_click("#add_row_arrow")
end
