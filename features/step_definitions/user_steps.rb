Given /^a user with login "([^\"]*)" and password "([^\"]*)" exists$/ do |login, password|
  attr = {
    :login => login, 
    :email => "#{login}@qfdonline.com", 
    :password => password, 
    :password_confirmation => password,
  }
  Factory.create("user", attr)
end

Given /^that I\'m logged in$/ do
  user = Factory.create("user")
  visit(login_path)
  fill_in "login", :with => user.login
  fill_in "password", :with => user.password
  click_button "Log in"
  When "I wait for the page to load"
end

