require 'spec_helper'

describe SessionsController do
  describe 'index' do
    it 'orders the sessions based on the passed in sort parameter' do
      Session.should_receive(:by_session_date)

      get :index, sort: 'by_session_date'
    end

    it 'reverses the order when the reverse param is passed in' do
      sessions = stub(:sessions)
      Session.stub(by_session_date: sessions)

      sessions.should_receive(:reverse!)

      get :index, sort: 'by_session_date', reverse: true
    end
  end

  describe 'new' do
    context 'as a logged out user' do
      it 'redirects to the signin-page' do
        get :new

        response.should redirect_to(signin_path)
      end
    end

    context 'as logged-in user without admin rights' do
      it 'redirects to sessions index' do
        @user = create_user
        controller_sign_in(@user)

        get :new

        response.should redirect_to(sessions_path)
      end
    end

    context 'as logged-in user with admin rights' do
      before(:each) do
        user = create_user
        user.toggle!(:admin)
        controller_sign_in(user)
      end

      it 'allows access' do
        get :new

        response.should be_successful
      end

      it 'loads the files in the file archive' do
        archive = SongsArchive::Directory.new(Rails.root.join('spec/fixtures/archive'))
        SongsArchive::Directory.should_receive(:new) { archive }

        get :new
      end

      context 'with sessions and songs already in DB' do
        before(:each) do
          @session = Session.create!(session_date: Date.strptime('2011.07.14','%Y.%m.%d'))
          @session.songs.create!(file_name: '01.golden_fields.mp3')
        end

        it 'does not assign the songs that are in the DB' do
          get :new

          assigns[:new_files]['2011.07.14'].should_not include('01.golden_fields.mp3')
        end

        it 'does not assign the sessions with all songs already in DB' do
          @session.songs.create!(file_name: '02.grapevine.mp3')

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
  end

  describe 'create' do
    let(:user) {
      create_user
    }

    context 'as logged-out user' do
      it 'redirects to sessions index' do
        post :create, sessions: { '2011.08.09' => ['01.testing.mp3']}

        response.should redirect_to(sessions_path)
      end
    end

    context 'as logged-in user without admin rights' do
      it 'redirects to sessions index' do
        controller_sign_in(user)

        post :create, sessions: { '2011.08.09' => ['01.testing.mp3']}

        response.should redirect_to(sessions_path)
      end
    end

    context 'as logged-in user with admin rights' do
      before(:each) do
        user.toggle!(:admin)
        controller_sign_in(user)
      end

      describe 'success with one session' do
        let(:attr) {
          { '2011.08.09' => ['01.testing.mp3', '02.testing.mp3'] }
        }

        it 'should create a session' do
          lambda do
            post :create, sessions: attr
          end.should change(Session, :count).by(1)
        end

        it 'should redirect to the sessions index page' do
          post :create, sessions: attr

          response.should redirect_to(sessions_path)
        end
      end

      describe 'success with multiple sessions' do
        let(:attr) {
          {
            '2011.08.09' => ['01.testing.mp3', '02.testing.mp3'],
            '2011.09.09' => ['01.testing.mp3', '02.testing.mp3']
          }
        }

        it 'should create multiple sessions' do
          lambda do
            post :create, sessions: attr
          end.should change(Session, :count).by(2)
        end

        it 'should redirect to the sessions index page' do
          post :create, :sessions => attr

          response.should redirect_to(sessions_path)
        end

        it 'should have success message' do
          post :create, sessions: attr

          flash[:success].should include 'Session 2011.08.09 saved!'
          flash[:success].should include 'Session 2011.08.09 saved!'
        end
      end
    end
  end

  describe 'destroy' do
    let(:user) {
      create_user
    }

    context 'as signed-out user' do
      it 'redirects to sigin-page' do
        delete :destroy, id: '1'

        response.should redirect_to(signin_path)
      end
    end

    context 'as logged-in user without admin rights' do
      it 'should protect page and redirect' do
        controller_sign_in(user)

        delete :destroy, id: '1'

        response.should redirect_to(sessions_path)
      end
    end

    context 'as logged-in user with admin rights' do
      before(:each) do
        @session = Session.create!(session_date: Time.now)
        @song    = @session.songs.create!(file_name: '01.file.mp3')

        user.toggle!(:admin)
        controller_sign_in(user)
      end

      it 'should delete the session' do
        lambda do
          delete :destroy, id: @session.id
        end.should change(Session, :count).by(-1)
      end

      it 'should delete associated songs' do
        lambda do
          delete :destroy, id: @session.id
        end.should change(Song, :count).by(-1)
      end

      it 'should delete tags associated to songs' do
        @song.tags.create!(name: 'great')

        lambda do
          delete :destroy, id: @session.id
        end.should change(Tag, :count).by(-1)
      end
    end
  end
end
