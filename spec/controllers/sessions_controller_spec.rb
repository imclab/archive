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
