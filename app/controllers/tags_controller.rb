class TagsController < ApplicationController
  before_filter :authorize,       :only => [:create, :destroy]
  before_filter :authorize_admin, :only => :destroy

  def index
    @title = "All tags"
    @tags = Tag.all_associated_with_songs
  end

  def show
    @tag = Tag.find(params[:id])
    @songs = @tag.songs
  end

  def create
    song = Song.find(params[:tag][:song_id])
    tag = Tag.find_or_create_by_name(params[:tag][:name])
    if tag.errors.any?
      flash_message :error, "Tag could not be added!"
      redirect_to song_path(params[:tag][:song_id])
    else
      song.tags << tag
      flash_message :success, "Tag \"#{tag.name}\" saved!"
      redirect_to song_path(params[:tag][:song_id])
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.song_tags.destroy_all
    tag.destroy
    flash_message :notification, "You successfully deleted a tag"
    redirect_to sessions_path
  end
end
