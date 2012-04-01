class CommentsController < ApplicationController
  before_filter :authorize,       :only => [:create, :destroy]
  before_filter :authorize_admin, :only => :destroy

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash_message :success, "You successfully added a comment!"
      redirect_to song_path(params[:comment][:song_id])
    else
      flash_message :error, "Comment could not be added!"
      redirect_to song_path(params[:comment][:song_id])
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    song = comment.song

    comment.destroy
    flash_message :notification, "You successfully deleted a comment"
    redirect_to song_path(song.id)
  end
end
