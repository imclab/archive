module ApplicationHelper

  def title
    base_title = "Howling Vibes Archive"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def render_flash_messages
    unless flash.empty?
      flash.each do |type, messages|
        messages.each do |m|
          concat content_tag :div, m, :class => "flash #{type}"
        end
      end
    end
  end

  def pretty_session_date(datetime)
    datetime.strftime("%d. %B %Y")
  end
end
