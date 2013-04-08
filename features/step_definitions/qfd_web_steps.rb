When /^I visit (.* page)$/ do |page_name|
  visit(path_to(page_name))
end

# useful for debugging selenium problems
When /^I wait for ((?:\d+\.)?\d+) seconds?$/ do |seconds|
  if "selenium" == Capybara.mode
    sleep seconds.to_f
  end
end
  
When /^I reload the page$/ do
  visit(page.driver.current_url)
end

