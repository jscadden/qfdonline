Given /^(?:that )?an? (.*) exists$/ do |model_name|
  model_name = model_name.camelize.downcase
  instance_variable_set("@#{model_name}", Factory.create(model_name))
end

Given /^the (.*) has a (.*)$/ do |parent_name, child_name|
  child_name = child_name.camelize.downcase
  parent_name = parent_name.camelize.downcase
  parent = instance_variable_get("@#{parent_name}")
  child = Factory.create(child_name, "#{parent_name}" => parent)
  instance_variable_set("@#{child_name}", child)
end
