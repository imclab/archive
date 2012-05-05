require 'spec_helper'

describe CommentsController do

  describe "POST 'create'" do
    before(:each) do
      @song = Song.create!(file_name: "01.testing.mp3")
      @user = create_user
      @attr = { song_id: @song.id, user_id: @user.id,
                text: "This is a testing comment!" }
    end

    describe "failure" do
      it "should not create comments as not-signed-in user" do
        lambda do
          post :create, comment: @attr
        end.should_not change(Comment, :count).by(1)

        response.should redirect_to(signin_path)
      end
    end

    describe "success" do
      it "should create comment as signed-in user" do
        controller_sign_in(@user)

        lambda do
          post :create, comment: @attr
        end.should change(Comment, :count).by(1)

        response.should redirect_to(song_path(@song.id))
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @song    = Song.create!(file_name: "01.testing.mp3")
      @user    = create_user
      @comment = Comment.create!(song_id: @song.id, user_id: @user.id,
                                 text: "This is a testing comment!")
    end

    describe "as non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @comment
        response.should redirect_to(signin_path)
      end
    end

    describe "as correct user" do
      before(:each) do
        controller_sign_in(@user)
      end

      it "should delete the comment" do
        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end
    end

    describe "as admin user" do
      before(:each) do
        @user.toggle!(:admin)
        controller_sign_in(@user)
      end

      it "should delete the comment" do
        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end

      it "should redirect" do
        delete :destroy, :id => @comment
        response.should redirect_to(song_path(@song.id))
      end
    end
  end
end
