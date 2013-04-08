When /^I log out$/ do
  visit(logout_path)
end

Then /^I should not see a link to the invited qfd$/ do
  qfd = Qfd.find_by_name("Test QFD")
  page.should_not have_css("a[href^='#{qfd_path(qfd)}']")
end

