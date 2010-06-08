Then /^I should see a flash notice indicating success$/ do
  page.should have_css(".flash.notice", :text => /success/i)
end

Then /^I should see a flash notice indicating that I\'m logged out$/ do
  page.should have_css(".flash.notice", :text => /log out success/i)
end

Then /^I should see a flash error indicating that permission is denied$/ do
  page.should have_css(".flash.error", :text => /permission denied/i)
end
