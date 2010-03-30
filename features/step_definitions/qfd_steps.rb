Then /^I should see the QFD\'s name$/ do
  response.should contain(@qfd.name)
end

Then /^a link to the QFD$/ do
  response.should have_tag("a[href=\"#{qfd_path(@qfd)}\"]")
end
