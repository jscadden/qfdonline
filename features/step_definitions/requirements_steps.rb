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
