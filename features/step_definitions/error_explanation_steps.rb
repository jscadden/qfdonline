Then /^I should see an explanation of the failure$/ do
  page.should have_css("#errorExplanation p", :text => "There were problems with the following fields:")
end
