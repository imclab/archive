require 'spec_helper'

describe Admin::SongTagsController do
  describe "#destroy" do
    let(:song1) do
      Song.create!(file_name: '01.testing.mp3')
    end

    let(:song2) do
      Song.create!(file_name: '02.testing.mp3')
    end

    let(:tag1) do
      song1.tags.create!(name: 'super')
    end

    let(:tag2) do
      song1.tags.create!(name: 'awesome')
    end

    before(:each) do
      admin = create_user
      admin.toggle!(:admin)
      controller_sign_in(admin)

      song2.tags << tag1
    end

    it 'deletes the relationship between a song and a tag' do
      song_tag = SongTag.where(song_id: song1.id, tag_id: tag1.id).first
      lambda do
        delete :destroy, id: song_tag.id
      end.should change(SongTag, :count).by(-1)
    end

    it 'redirects to the songs show action' do
      song_tag = SongTag.where(song_id: song1.id, tag_id: tag1.id).first
      delete :destroy, id: song_tag.id

      response.should redirect_to(admin_song_path(song1.id))
    end

    it 'does not delete tags if they are associated with other songs' do
      song_tag = SongTag.where(song_id: song1.id, tag_id: tag1.id).first
      lambda do
        delete :destroy, id: song_tag.id
      end.should_not change(Tag, :count).by(-1)
    end

    it 'deletes tags if they are not associated with other songs' do
      song_tag = SongTag.where(song_id: song1.id, tag_id: tag2.id).first
      lambda do
        delete :destroy, id: song_tag.id
      end.should change(Tag, :count).by(-1)
    end
  end
end
