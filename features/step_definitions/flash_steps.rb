Then /^I should see a flash notice indicating success$/ do
  response.should have_tag(".flash.notice", /success/i)
end

Then /^I should see a flash notice indicating that I\'m logged out$/ do
  response.should have_tag(".flash.notice", /log out success/i)
end

Then /^I should see a flash error indicating that permission is denied$/ do
  response.should have_tag(".flash.error", /permission denied/i)
end
