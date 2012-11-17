require 'spec_helper'

describe TagsController do
  let(:song) {
    Song.create!(file_name: 'testing.mp3')
  }

  let(:user) {
    create_user
  }

  describe 'index' do
    it 'should show all the associated tags' do
      unassociated_tag = Tag.create!(name: 'unassociated')
      associated_tag   = Tag.create!(name: 'associated')

      song.tags << associated_tag

      get :index
      assigns[:tags].should == [associated_tag]
    end
  end

  describe 'show' do
    it 'should find the right tag' do
      tag = stub(:tag, songs: [])

      Tag.should_receive(:find).with('1').and_return(tag)

      get :show, id: '1'
    end

    it 'should find the associated songs' do
      tag = stub(:tag, songs: [])
      Tag.stub(find: tag)

      get :show, id: '1'

      assigns(:songs).should == tag.songs
    end
  end

  describe 'create' do
    context 'as a logged-in user' do
      before(:each) do
        controller_sign_in(user)
      end

      context 'with the invalid attributes' do
        it "should not create a tag" do
          lambda do
            post :create, tag: { name: '', song_id: song.id }
          end.should_not change(Tag, :count).by(1)
        end

        it 'should redirect to the songs page' do
          post :create, tag: { name: '', song_id: song.id }

          response.should redirect_to(song_path(song))
        end
      end

      context 'with valid attributes' do
        before(:each) do
          @attr = { :name => "greeeat!", :song_id => song.id }
        end

        it 'should create a tag' do
          lambda do
            post :create, tag: { name: 'great!', song_id: song.id }
          end.should change(Tag, :count).by(1)
        end

        it 'should add association between tag and song' do
          lambda do
            post :create, tag: { name: 'great!', song_id: song.id }
          end.should change(SongTag, :count).by(1)
        end

        it "should redirect to songs page" do
          post :create, tag: { name: 'great!', song_id: song.id }

          response.should redirect_to(song_path(song))
        end
      end
    end

    context 'as logged-out user' do
      it 'should redirect to the signin-path' do
        post :create, tag: {name: 'great', song_id: song.id}

        response.should redirect_to(signin_path)
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      @tag = song.tags.create!(name: 'great')
    end

    context 'as logged-out user' do
      it 'should redirect to the signin-path' do
        delete :destroy, id: @tag.id

        response.should redirect_to(signin_path)
      end
    end

    context 'as logged-in user without admin rights' do
      it 'should redirect to the sessions index' do
        controller_sign_in(create_user)

        delete :destroy, id: @tag.id

        response.should redirect_to(sessions_path)
      end
    end

    context 'as user with admin rights' do
      before(:each) do
        user.toggle!(:admin)
        controller_sign_in(user)
      end

      it 'should delete the tag' do
        lambda do
          delete :destroy, id: @tag.id
        end.should change(Tag, :count).by(-1)
      end

      it 'should delete associated SongTags' do
        lambda do
          delete :destroy, id: @tag.id
        end.should change(SongTag, :count).by(-1)
      end

      it 'should redirect to the sessions index' do
        delete :destroy, id: @tag.id

        response.should redirect_to(sessions_path)
      end
    end
  end
end
