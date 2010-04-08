Given /^an anonymous user$/ do
  visit(root_path)
end

Then /^I should see the login form$/ do
  response.body.should have_tag("input[name='user_session[login]']")
  response.body.should have_tag("input[name='user_session[password]']")
end

Given /^that I\'m logged in as "([^\"]+)"$/ do |login|
  visit(login_path)
  When "I wait for the page to load"
  fill_in "login", :with => login
  fill_in "password", :with => "password"
  click_button "Log in"
  When "I wait for the page to load"
end

