Given /^(?:that )?an? (.*) exists$/ do |model_name|
  model_name = model_name.camelize.downcase
  instance_variable_set("@#{model_name}", Factory.create(model_name))
end
