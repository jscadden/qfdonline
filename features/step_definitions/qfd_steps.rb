Given /^I\'m on the new QFD form$/ do
  visit(new_qfd_path)
end

Given /^I\'ve created a QFD$/ do
  @qfd = Factory.create("qfd")
  assigns["current_user"].qfds << @qfd
end

Given /^I\'m viewing the QFD$/ do
  visit(qfd_path(@qfd))
end

# Then /^I should be redirected to the page of the QFD\'s first HOQ$/ do
#   current_path = URI.parse(current_url).select(:path, :query).compact.join('?')
#   current_path.should == qfd_hoq_path(assigns["qfd"], assigns["hoq"])
# end
