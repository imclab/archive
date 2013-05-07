require 'spec_helper'

describe Admin::SongsController do
  before(:each) do
    admin = create_user
    admin.toggle!(:admin)
    controller_sign_in(admin)
    session = Session.create!(session_date: Time.now)
    @song = session.songs.create!(file_name: '01.testing.mp3')
  end

  describe 'show' do
    it 'loads the song' do
      songs_stub = stub(:songs_with_include)

      Song.should_receive(:includes).and_return(songs_stub)
      songs_stub.should_receive(:find).with(@song.id.to_s)

      get :show, id: @song.id
    end
  end

  describe 'destroy' do
    it 'deletes a song' do
      lambda do
        delete :destroy, id: @song.id
      end.should change(Song, :count).by(-1)
    end
  end
end
