class SongsController < ApplicationController
  def index
    @songs = Song.all
    @title = "All songs"
  end

  def show
    @song = Song.find(params[:id])
    @title = @song.file_name
  end
end
