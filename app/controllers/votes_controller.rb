class VotesController < ApplicationController
  def create
    @song = Song.find(params[:song_id])
    params[:direction] == 'up' ? @song.increment!(:score) : @song.decrement!(:score)
    expire_fragment('all_sessions_with_songs')

    respond_to do |format|
      format.html { redirect_to song_path(@song) }
      format.js
    end
  end
end
