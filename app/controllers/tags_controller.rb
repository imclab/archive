class TagsController < ApplicationController
  before_filter :authorize,       only: [:create, :destroy]
  before_filter :authorize_admin, only: :destroy

  def index
    @title = 'All tags'
    @tags  = Tag.all_associated_with_songs
  end

  def show
    @tag   = Tag.find(params[:id])
    @songs = @tag.songs
  end

  def create
    @song = Song.find(params[:tag][:song_id])
    @tag  = Tag.find_or_create_by(name: params[:tag][:name])

    respond_to do |format|
      if @tag.errors.any?
        format.html do 
          flash_message :error, 'Tag could not be added!'
          redirect_to song_path(@song)
        end
      else
        @song.tags << @tag

        expire_fragment('all_sessions_with_songs')

        format.html do
          flash_message :success, "Tag \"#{@tag.name}\" saved!"
          redirect_to song_path(@song)
        end
        format.js
      end
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.song_tags.destroy_all
    tag.destroy

    expire_fragment('all_sessions_with_songs')

    flash_message :notification, 'You successfully deleted a tag'
    redirect_to sessions_path
  end
end
