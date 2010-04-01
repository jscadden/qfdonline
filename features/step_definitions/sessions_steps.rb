Given /^an anonymous user$/ do
  visit(root_path)
end

Then /^I should see the login form$/ do
  response.should have_tag("input[name='user_session[login]']")
  response.should have_tag("input[name='user_session[password]']")
end
