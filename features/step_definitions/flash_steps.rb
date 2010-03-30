Then /^I should see a flash notice indicating success$/ do
  response.should have_tag(".flash.notice", /success/)
end
