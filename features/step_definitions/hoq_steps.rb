Given /^(?:that )?an? HOQ exists$/ do
  @hoq = Factory.create(:hoq, :qfd => @qfd)
end

Then /^I should see the HOQ\'s name$/ do
  response.should contain(@hoq.name)
end

Then /^a link to the HOQ$/ do
  response.should have_tag("a[href=\"#{hoq_path(@hoq)}\"]")
end
