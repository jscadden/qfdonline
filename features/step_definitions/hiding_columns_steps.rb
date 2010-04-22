Given /^a hiding_columns_test user exists$/ do
  user = Factory.create("hiding_columns_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I right click on the column \#1\'s number cell$/ do
  if Webrat.configuration.mode == :selenium
    pending("context menus disabled")
    css = "css=.row > .num:contains('1')"
    selenium.mouse_down_right(css)
    selenium.mouse_up_right(css)
  end
end

When /^I click on \"([^\"]+)\" in the column menu/ do |link|
  click_link_within("#column_menu", link)
end

Then /^I should (?:still )?not see column \#1$/ do
  css = "css=.row > .num:contains('1')"
  if Webrat.configuration.mode == :selenium
    selenium.is_visible(css).should be_false
  end
end
