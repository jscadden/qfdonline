When /^I visit (.*) page$/ do |page_name|
  visit(path_to(page_name))
end
