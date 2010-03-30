# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_flash
    flash.inject("") do |output, kv_pair|
      type, message = kv_pair
      output += content_tag("div", h(message), :class => "flash #{type}")
    end
  end
end
