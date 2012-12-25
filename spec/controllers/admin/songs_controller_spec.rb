require 'spec_helper'

describe Admin::SongsController do
  before(:each) do
    admin = create_user
    admin.toggle!(:admin)
    controller_sign_in(admin)
  end

  describe 'destroy' do
    before(:each) do
      session = Session.create!(session_date: Time.now)
      @song = session.songs.create!(file_name: '01.testing.mp3')
    end

    it 'deletes a song' do
      lambda do
        delete :destroy, id: @song.id
      end.should change(Song, :count).by(-1)
    end
  end
end
