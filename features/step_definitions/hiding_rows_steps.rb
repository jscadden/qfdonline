Given /^a hiding_rows_test user exists$/ do
  user = Factory.create("hiding_rows_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I right click on the row \#1\'s number cell$/ do 
  css = ".row > .num:first-child:contains('1')"
  right_click(css)
end

When /^I click on \"([^\"]+)\" in the row menu/ do |link|
  page.find("#row_menu").should be_visible
  within("#row_menu") do
    click(link)
  end
end

Then /^I should (?:still )?not see row \#1$/ do
  css = "css=.row > .num:first-child:contains('1')"
  selenium.is_visible(css).should be_false
end
