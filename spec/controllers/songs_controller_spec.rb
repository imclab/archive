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

  describe 'destroy' do
    context 'as non-signed-in user' do
      it 'redirect to signin-path' do
        delete :destroy, id: '1'

        response.should redirect_to(signin_path)
      end
    end

    context 'as non-admin user' do
      it 'should redirect to sessions index' do
        controller_sign_in(create_user)

        delete :destroy, id: '1'

        response.should redirect_to(sessions_path)
      end
    end

    context 'as user with admin rights' do
      before(:each) do
        @song = Song.create!(file_name: '01.file.mp3')

        user  = create_user
        user.toggle!(:admin)
        controller_sign_in(user)
      end

      it 'should delete the song' do
        lambda do
          delete :destroy, id: @song.id
        end.should change(Song, :count).by(-1)
      end

      it 'should redirect to sessions index after deleting the song' do
        delete :destroy, id: @song.id

        response.should redirect_to(sessions_path)
      end
    end
  end
end
