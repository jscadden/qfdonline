Given /^a user with email "([^\"]*)" and password "([^\"]*)" exists$/ do |email, password|
  attr = {
    :email => email,
    :password => password, 
    :password_confirmation => password,
    :verified_at => Time.now,
  }
  Factory.create("user", attr)
end
