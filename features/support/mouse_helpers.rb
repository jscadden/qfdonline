module MouseHelpers
  def double_click(css_selector)
    js = "$('#{css_selector}').dblclick()"
    page.driver.browser.execute_script(js)
  end

  def right_click(css_selector)
    # NOTE I have reason to believe this will only work in firefox
    js = <<EOS
var event = document.createEvent("MouseEvents");
event.initMouseEvent("mousedown", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 2, null); 
var element = $("#{css_selector}").get(0);
element.dispatchEvent(event);

var event = document.createEvent("MouseEvents");
event.initMouseEvent("mouseup", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 2, null); 
var element = $("#{css_selector}").get(0);
element.dispatchEvent(event);
EOS
    page.driver.browser.execute_script(js)
  end
end
World(MouseHelpers)
