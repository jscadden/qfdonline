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

