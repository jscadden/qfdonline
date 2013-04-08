Given /^the QFD\'s first HOQ\'s first (primary|secondary) requirement is named "([^\"]*)"$/ do |pri_sec, name|
  qfd = latest_qfd
  hoq = qfd.hoqs.first
  case pri_sec
  when "primary"
    req = hoq.primary_requirements.first
  when "secondary"
    req = hoq.secondary_requirements.first
  else
    fail "unknown type of requirement #{pri_sec.inspect}"
  end
  req.update_attributes!(:name => name)
end

Then /^I shouldn\'t see a (?:primary|secondary) requirement named "([^\"]*)"$/ do |name|
  page.should_not have_content(name)
end

Given /^I\'ve a QFD with (\d+) (primary|secondary) requirements$/ do |num, pri_sec|
  Given "I've a QFD"
  qfd = latest_qfd
  hoq = qfd.hoqs.first
  num = num.to_i
  list = nil
  count = nil

  case pri_sec
  when "primary"
    list = hoq.primary_requirements_list.requirements
    count = hoq.primary_requirements.count
  when "secondary"
    list = hoq.secondary_requirements_list.requirements
    count = hoq.secondary_requirements.count
  else
    fail "unknown type of requirement #{pri_sec.inspect}"
  end

  num_req_to_build = [num - count, 0].max
  num_req_to_build.times do |x|
    req = Factory("requirement", :name => "New Requirement #{x}")
    list << req
  end
end

When /^I right click on row \#(\d+)\'s number cell$/ do |row_num|
  right_click(".matrix .row:nth-of-type(#{5+row_num.to_i}) .num")
end

Then /^I should see that row \#(\d+)\'s requirement is named "([^\"]*)"$/ do |row_num, name|
  page.should have_css(".matrix .row:nth-of-type(#{5+row_num.to_i}) span.name", :text => /#{name}/)
end

When /^I right click on column \#(\d+)\'s number cell$/ do |col_num|
  right_click(".matrix .row:first-child .num:nth-child(#{5+col_num.to_i})")
end

Then /^I should see that column \#(\d+)\'s requirement is named "([^\"]*)"$/ do |col_num, name|
  page.should have_css(".matrix .row:nth-of-type(5) .name:nth-child(#{5+col_num.to_i}) span.name", :text => /#{name}/)
end
