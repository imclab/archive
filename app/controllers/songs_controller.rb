class SongsController < ApplicationController
  skip_filter :authorize

  def index
    @songs = Song.all
    @title = "All songs"
  end

  def show
    @song = Song.find(params[:id])
    @tag = Tag.new
    @title = @song.file_name
  end
end
