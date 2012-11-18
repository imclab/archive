require 'spec_helper'

describe VotesController do
  before(:each) do
    @song = Song.create!(file_name: "01.testing.mp3")
  end

  describe 'create' do
    it 'increments the score of a song' do
      post :create, song_id: @song.id, direction: 'up'

      @song.reload

      @song.score.should == 1
    end

    it 'decrements the score of a song' do
      post :create, song_id: @song.id, direction: 'down'

      @song.reload

      @song.score.should == -1
    end

    it 'redirects to song page' do
      post :create, song_id: @song.id

      response.should redirect_to(song_path(@song))
    end
  end
end
