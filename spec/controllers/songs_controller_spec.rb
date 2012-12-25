require 'spec_helper'

describe SongsController do
  describe 'index' do
    it 'should be successful' do
      get :index
      response.should be_success
    end

    it 'orders the songs based on the passed sort parameter' do
      Song.should_receive(:by_count_of_tags)

      get :index, sort: 'by_count_of_tags'
    end

    it 'reversed the order when the reverse param is passed in' do
      songs = stub(:song)
      Song.stub(by_count_of_tags: songs)

      songs.should_receive(:reverse!)

      get :index, sort: 'by_count_of_tags', reverse: true
    end
  end

  describe 'show' do
    it 'find the right song' do
      song = stub(:song, file_name: '01.breaking.bad.mp3')

      Song.should_receive(:find).with('1').and_return(song)

      get :show, id: '1'
    end

    it 'saves the current path in session variable' do
      song = stub(:song, file_name: '01.breaking.bad.mp3')
      Song.stub(find: song)

      get :show, id: '1'

      session[:return_to].should == song_path('1')
    end
  end
end
