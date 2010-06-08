Given /^an anonymous user$/ do
  visit(root_path)
end

Then /^I should see the login form$/ do
  page.should have_css("input[name='user_session[login]']")
  page.should have_css("input[name='user_session[password]']")
end

Given /^that I\'m logged in as "([^\"]+)"$/ do |login|
  visit(login_path)
  fill_in "Login", :with => login
  fill_in "Password", :with => "password"
  click_button "Log in"
end

