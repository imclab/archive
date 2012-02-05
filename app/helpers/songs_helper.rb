module SongsHelper
  def song_download_link(song)
    base_url = Pathname.new(PATHS['download_url']) 
    url = base_url.join(prettify_date(song.session.session_date),
                        song.file_name)
    link_to song.file_name, url.to_s
  end

  def absolute_song_url(song)
    base_url = Pathname.new(PATHS['download_url']) 
    base_url.join(prettify_date(song.session.session_date), song.file_name).to_s
  end
end
