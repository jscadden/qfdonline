Then /^I should see the row context menu$/ do
  page.should have_css("#row_menu.contextMenu")
end

Then /^I should see the column context menu$/ do
  page.should have_css("#column_menu.contextMenu")
end
