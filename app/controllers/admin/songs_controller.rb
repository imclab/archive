class Admin::SongsController < Admin::BaseController
  def index
    @songs = Song.includes(:session)
  end

  def show
    @song = Song.includes(song_tags: :tag, comments: :user).find(params[:id])
  end

  def destroy
    Song.find(params[:id]).destroy

    expire_fragment('all_sessions_with_songs')

    flash_message :notification, 'Song successfully deleted.'
    redirect_to admin_songs_path
  end
end
