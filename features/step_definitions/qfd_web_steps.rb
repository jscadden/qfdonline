When /^I visit (.* page)$/ do |page_name|
  visit(path_to(page_name))
end

When /^I wait for the page to load$/ do
  if Webrat.configuration.mode == :selenium
    selenium.wait_for_page_to_load
  end
end

# useful for debugging selenium problems
When /^I wait for ((?:\d+\.)?\d+) seconds?$/ do |seconds|
  if Webrat.configuration.mode == :selenium
    sleep seconds.to_f
  end
end

When /^I wait for ajax$/ do 
  if Webrat.configuration.mode == :selenium
    # jquery equivalent of selenium.wait_for_ajax from
    # http://web.elctech.com/2008/11/10/jquery-ajax-loading-and-selenium-respec-testing/
    selenium.wait_for_condition('selenium.browserbot.getCurrentWindow().jQuery.active == 0', 5.seconds)
  end
end
  
