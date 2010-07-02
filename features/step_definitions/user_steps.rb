Given /^a user with login "([^\"]*)" and password "([^\"]*)" exists$/ do |login, password|
  attr = {
    :login => login, 
    :email => "#{login}@qfdonline.com", 
    :password => password, 
    :password_confirmation => password,
    :verified_at => Time.now,
  }
  Factory.create("user", attr)
end
