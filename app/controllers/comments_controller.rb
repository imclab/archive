class CommentsController < ApplicationController
  before_filter :authorize,                only: :create
  before_filter :correct_user_or_admin,    only: :destroy

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
    flash_message :notification, 'You successfully deleted a comment!'
    redirect_to song_path(song.id)
  end

  private

    def correct_user_or_admin
      comment = Comment.find(params[:id])
      song    = comment.song
      unless current_user && (current_user?(comment.user) || current_user.admin)
        redirect_to(signin_path)
      end
    end
end
