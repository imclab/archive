class VotesController < ApplicationController
  def create
    song = Song.find(params[:song_id])
    params[:direction] == 'up' ? song.increment!(:score) : song.decrement!(:score)
    redirect_to song_path(song)
  end
end
