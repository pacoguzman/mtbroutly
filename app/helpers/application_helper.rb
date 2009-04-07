# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_ajax_messages(message = {})
    content_tag(:div, :id => "ajax_messages" ) do
      message.collect{|entry|
        content_tag(:div, entry[1], :class => "notice #{entry[0]}")
      }
    end
  end
end
