Given /^I\'m an anonymous user$/ do
  visit(logout_path)
  visit(root_path)
end

When /^I register$/ do
  do_registration
end

Then /^I should receive a verification email$/ do
  Then "I should receive an email with subject \"Please verify your QFDOnline Registration\""
end

Given /^I\'ve received a verification email$/ do
  Factory("unverified_user", :email => "example@example.com")
end

When /^I follow the verification link$/ do
  open_email("example@example.com")
  click_email_link_matching(/users\/verify/)
end

Then /^I should be logged in$/ do
  page.should have_content("Welcome #{latest_user.login}")
  page.should have_css("a[href='#{logout_path}']")
end
