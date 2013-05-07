require 'spec_helper'

describe Admin::SessionsController do
  before(:each) do
    user = create_user
    user.toggle!(:admin)
    controller_sign_in(user)
  end

  describe 'new' do
    context 'with no session and songs already saved' do
      it 'loads the addable files in the file archive' do
        archive = SongsArchive::Directory.new(Rails.root.join('spec/fixtures/archive'))
        SongsArchive::Directory.should_receive(:new).and_return(archive)

        get :new

        assigns[:new_files]['2011.07.14'].should include('01.golden_fields.mp3')
      end
    end

    context 'with sessions and songs already in DB' do
      let(:session) do
        Session.create!(session_date: Date.strptime('2011.07.14','%Y.%m.%d'))
      end

      before(:each) do
        session.songs.create!(file_name: '01.golden_fields.mp3')
      end

      it 'does not assign the songs that are in the DB' do
        get :new

        assigns[:new_files]['2011.07.14'].should_not include('01.golden_fields.mp3')
      end

      it 'does not assign the sessions with all songs already in DB' do
        session.songs.create!(file_name: '02.grapevine.mp3')

        get :new

        assigns[:new_files].should_not have_key('2011.07.14')
      end

      it 'assigns the sessions and songs that are not in DB yet' do
        get :new

        assigns[:new_files].should have_key('2011.07.01')
        assigns[:new_files]['2011.07.14'].should include('02.grapevine.mp3')
      end
    end
  end

  describe 'create' do
    it 'creates a new session' do
      attributes = { '2011.08.09' => ['01.testing.mp3', '02.testing.mp3'] }

      lambda do
        post :create, sessions: attributes
      end.should change(Session, :count).by(1)
    end

    it 'creates multiple sessions' do
      attributes = {
        '2011.08.09' => ['01.testing.mp3', '02.testing.mp3'],
        '2011.09.09' => ['01.testing.mp3', '02.testing.mp3']
      }

      lambda do
        post :create, sessions: attributes
      end.should change(Session, :count).by(2)
    end
  end

  describe 'destroy' do
    let(:session) do
      Session.create!(session_date: Date.strptime('2011.07.14','%Y.%m.%d'))
    end

    let(:song) do
      session.songs.create!(file_name: '01.golden_fields.mp3')
    end

    before(:each) do
      session.touch
      song.touch
    end

    it 'allows me to delete a session' do
      lambda do
        delete :destroy, id: session.id
      end.should change(Session, :count).by(-1)
    end

    it 'should delete associated songs' do
      lambda do
        delete :destroy, id: session.id
      end.should change(Song, :count).by(-1)
    end

    it 'should delete tags associated to songs' do
      song.tags.create!(name: 'great')

      lambda do
        delete :destroy, id: session.id
      end.should change(Tag, :count).by(-1)
    end
  end
end
