module ApplicationHelper

  def title
    base_title = "Howling Vibes Archive"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
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

  def prettify_date(date)
    date.strftime("%Y.%m.%d")
  end

  def short_song_info(song)
    sentence  = "#{song.score} Votes, "
    sentence += "#{song.comments.length} Comments"

    if song.tags.any?
      sentence += ", Tags: "
      sentence += song.tags.collect { |t| "<b>#{t.name}</b>" }.to_sentence
      sentence  = truncate sentence, length: 120, separator: ","
    end

    raw sentence
  end
end
