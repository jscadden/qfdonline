Given /^a hiding_rows_test user exists$/ do
  user = Factory.create("hiding_rows_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I right click on the row \#1\'s number cell$/ do
  if Webrat.configuration.mode == :selenium
    css = "css=.row > .num:first-child:contains('1')"
    selenium.mouse_down_right(css)
    selenium.mouse_up_right(css)
  end
end

When /^I click on \"([^\"]+)\" in the row menu/ do |link|
  click_link_within("#row_menu", link)
end

Then /^I should (?:still )?not see row \#1$/ do
  css = "css=.row > .num:first-child:contains('1')"
  if Webrat.configuration.mode == :selenium
    selenium.is_visible(css).should be_false
  end
end
