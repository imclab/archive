require 'spec_helper'

describe Admin::SongTagsController do
  describe "#destroy" do
    let(:song) do
      Song.create!(file_name: '01.testing.mp3')
    end

    let(:tag) do
      song.tags.create!(name: 'super')
    end

    before(:each) do
      admin = create_user
      admin.toggle!(:admin)
      controller_sign_in(admin)
    end

    it 'deletes the relationship between a song and a tag' do
      song_tag = SongTag.where(song_id: song.id, tag_id: tag.id).first

      lambda do
        delete :destroy, id: song_tag.id
      end.should change(SongTag, :count).by(-1)
    end

    it 'does not delete tags if they are associated with other songs' do
      song2 = Song.create!(file_name: '02.testing.mp3')
      song2.tags << tag

      song_tag = SongTag.where(song_id: song.id, tag_id: tag.id).first

      lambda do
        delete :destroy, id: song_tag.id
      end.should_not change(Tag, :count).by(-1)
    end

    it 'deletes tags if they are not associated with other songs' do
      song_tag = SongTag.where(song_id: song.id, tag_id: tag.id).first

      lambda do
        delete :destroy, id: song_tag.id
      end.should change(Tag, :count).by(-1)
    end

    it 'redirects to the songs show action' do
      song_tag = SongTag.where(song_id: song.id, tag_id: tag.id).first

      delete :destroy, id: song_tag.id

      response.should redirect_to(admin_song_path(song.id))
    end
  end
end
