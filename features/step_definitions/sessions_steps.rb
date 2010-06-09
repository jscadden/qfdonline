Then /^I should see the login form$/ do
  page.should have_css("input[name='user_session[login]']")
  page.should have_css("input[name='user_session[password]']")
end

Given /^(?:that\s+)?I\'m logged in as "([^\"]+)"$/ do |login|
  visit(login_path)
  fill_in "Login", :with => login
  fill_in "Password", :with => "password"
  click_button "Log in"
  page.should have_content("Welcome #{login}")
end

