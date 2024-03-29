Given /^I\'ve created a primary requirement$/ do
  @hoq.primary_requirements_list << Factory.build("requirement")
end

Given /^I\'ve created a secondary requirement$/ do
  @hoq.secondary_requirements_list << Factory.build("requirement")
end

When /^I double click on the first rating\'s cell$/ do
  double_click(".rating")
end

Then /^I should see "([^\"]*)" in the rating\'s cell$/ do |value|
  within(".value") do
    page.should have_content(value)
  end
end

Then /^I should see "([^\"]*)" in the rating\'s row\'s maximum cell$/ do |value|
  within(:xpath, "//*[contains(@class, 'row') and (position() > 3)]//*[contains(@class, 'maximum')][1]") do
    page.should have_content(value)
  end
end

Given /^a ratings_test user exists$/ do
  user = Factory.create("ratings_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

When /^I should not see a rating select$/ do
  page.should_not have_css("select[name='rating[value]']")
end

