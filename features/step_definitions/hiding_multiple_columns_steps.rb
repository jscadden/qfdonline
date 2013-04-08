When /^I select two columns$/ do
  pending "Selenium doesn't seem to be able to handle this yet"
  if Webrat.configuration.mode == :selenium
    one_css = "css=.row > .num:contains('1')"
    two_css = "css=.row > .num:contains('2')"
    selenium.mouse_down_right(one_css)
    selenium.mouse_move(two_css)
    selenium.mouse_up_right(two_css)
  end
end

Then /^I should not see the two selected columns$/ do
  1.upto(2) do |num|
    css = "css=.row > .num:contains('#{num}')"
    if Webrat.configuration.mode == :selenium
      selenium.is_visible(css).should be_false
    end
  end
end
