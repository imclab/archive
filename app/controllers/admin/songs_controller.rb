class Admin::SongsController < Admin::BaseController
  def index
    @songs = Song.includes(:session)
  end

  def destroy
    Song.find(params[:id]).destroy
    flash_message :notification, 'Song successfully deleted.'
    redirect_to admin_songs_path
  end
end
