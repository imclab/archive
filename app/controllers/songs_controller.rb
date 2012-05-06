class SongsController < ApplicationController
  before_filter :authorize,             :only => :destroy
  before_filter :authorize_admin,       :only => :destroy
  before_filter :remember_current_path, :only => :show

  def index
    valid_options = ["by_count_of_tags", "by_session_date", "by_score"]
    if valid_options.include? params[:sort]
      @songs = Song.send(params[:sort])
      @songs.reverse! if params[:reverse]
    else
      @songs = Song.includes(:tags, :comments)
    end
    @title = "All songs"
  end

  def show
    @song    = Song.find(params[:id])
    @tag     = Tag.new
    @comment = Comment.new
    @title   = @song.file_name
  end

  def destroy
    Song.find(params[:id]).destroy
    flash_message :notification, "You successfully deleted a song"
    redirect_to sessions_path
  end

  protected

    def remember_current_path
      session[:return_to] = request.fullpath
    end
end
