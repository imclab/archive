class Admin::SongTagsController < Admin::BaseController
  def destroy
    song_tag = SongTag.find(params[:id])
    song_tag.destroy

    tag = Tag.find(song_tag.tag_id)
    if tag.songs.empty?
      tag.destroy
      flash_message :notification, 'Tag removed from song and deleted.'
    else
      flash_message :notification, 'Tag removed from song.'
    end

    redirect_to admin_song_path(song_tag.song_id)
  end
end
