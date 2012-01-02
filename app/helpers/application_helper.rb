module ApplicationHelper

  def title
    base_title = "Howling Vibes Archive"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def render_flash
    unless flash.empty?
      flash.each do |key, value|
        value.each do |m|
          content_tag(:div, m, :class => "flash #{key}")
        end
      end
    end
  end
end
