Then /^I should see an explanation of the failure$/ do
  response.should have_tag("#errorExplanation") do |t|
    t.should have_tag("p", "There were problems with the following fields:")
  end
end
