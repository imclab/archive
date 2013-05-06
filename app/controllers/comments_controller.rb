class CommentsController < ApplicationController
  before_filter :authorize,                only: :create
  before_filter :correct_user_or_admin,    only: :destroy

  def create
    comment = Comment.new(params[:comment])

    if comment.save
      expire_fragment('all_sessions_with_songs')

      flash_message :success, "You successfully added a comment!"
      redirect_to song_path(params[:comment][:song_id])
    else
      flash_message :error, "Comment could not be added!"
      redirect_to song_path(params[:comment][:song_id])
    end
  end

  def destroy
    @comment.destroy

    expire_fragment('all_sessions_with_songs')

    flash_message :notification, 'You successfully deleted a comment!'
    redirect_to song_path(@comment.song)
  end

  private

    def correct_user_or_admin
      @comment = Comment.find(params[:id])
      unless current_user && (current_user?(@comment.user) || current_user.admin)
        redirect_to(signin_path)
      end
    end
end
