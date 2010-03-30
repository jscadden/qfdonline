When /^I visit (.*)$/ do |page_name|
  visit path_to(page_name)
end

Given /^that I\'m on the new (.*) form$/ do |model_name|
  model_name = model_name.camelize.downcase
  visit(send("new_#{model_name}_path"))
end


