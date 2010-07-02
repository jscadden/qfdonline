Then /^I should see the login form$/ do
  page.should have_css("input[name='user_session[email]']")
  page.should have_css("input[name='user_session[password]']")
end

Given /^(?:that\s+)?I\'m logged in as "([^\"]+)"$/ do |email|
  unless /@qfdonline.com$/ === email
    email += "@qfdonline.com"
  end
  unless User.exists?(:email => email)
    @current_user = Factory("user", :email => email)
  end
  visit(login_path)
  fill_in "Email", :with => email
  fill_in "Password", :with => "password"
  click_button "Log in"
  page.should have_content("Welcome #{email}")
end

Given /^that I\'m logged in$/ do
  Given "that I'm logged in as \"test_user\""
end
