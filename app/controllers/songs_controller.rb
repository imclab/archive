class SongsController < ApplicationController
  before_filter :authorize,       :only => :destroy
  before_filter :authorize_admin, :only => :destroy

  def index
    @songs = Song.all
    @title = "All songs"
  end

  def show
    @song = Song.find(params[:id])
    @tag = Tag.new
    @title = @song.file_name
  end

  def destroy
    song = Song.find(params[:id])
    song.destroy
    flash_message :notification, "You successfully deleted a song"
    redirect_to sessions_path
  end
end
