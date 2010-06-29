Given /^a hiding_columns_test user exists$/ do
  user = Factory.create("hiding_columns_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I right click on the column \#1\'s number cell$/ do
  right_click(".row > .num:contains('1')")
end

When /^I click on \"([^\"]+)\" in the column menu/ do |link|
  page.find("#column_menu").should be_visible
  within("#column_menu") do
    click(link)
  end
end

Then /^I should (?:still )?not see column \#1$/ do
  page.find(".row > .num:contains('1')").should_not be_visible
end
