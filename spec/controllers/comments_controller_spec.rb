require 'spec_helper'

describe CommentsController do
  describe 'create' do
    before(:each) do
      song = Song.create!(file_name: '01.testing.mp3')
      @user = create_user
      @attr = { song_id: song.id, user_id: @user.id, text: 'testing' }
    end

    context 'as logged-out user' do
      it 'should not create a new comment' do
        lambda do
          post :create, comment: @attr
        end.should_not change(Comment, :count).by(1)
      end
    end

    context 'as logged-in user' do
      it 'should create a new comment' do
        controller_sign_in(@user)

        lambda do
          post :create, comment: @attr
        end.should change(Comment, :count).by(1)
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @song    = Song.create!(file_name: '01.testing.mp3')
      @user    = create_user
      @comment = Comment.create!(song_id: @song.id, user_id: @user.id, text: 'test')
    end

    context 'as logged-out user' do
      it 'redirect to sigin-path' do
        delete :destroy, id: @comment.id

        response.should redirect_to(signin_path)
      end
    end

    describe 'as logged-in user that did not create the comment' do
      it 'should redirect to the sigin-path' do
        wrong_user = create_user('new_user@gmail.com')
        controller_sign_in(wrong_user)

        delete :destroy, id: @comment.id

        response.should redirect_to(signin_path)
      end
    end

    describe 'as logged-in user that created the comment' do
      it 'should delete the comment' do
        controller_sign_in(@user)

        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end
    end

    describe 'as logged-in user with admin rights' do
      before(:each) do
      end

      it 'should delete the comment' do
        @user.toggle!(:admin)
        controller_sign_in(@user)

        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end
    end
  end
end
