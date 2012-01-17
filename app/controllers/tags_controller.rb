class TagsController < ApplicationController
  def index
    @title = "All tags"
    @tags = Tag.all_associated_with_songs
  end

  def show
    @tag = Tag.find(params[:id])
    @songs = @tag.songs
  end

  def create
    @song = Song.find(params[:tag][:song_id])
    @tag = Tag.find_or_create_by_name(params[:tag][:name])
    @association = @tag.song_tags.find_or_create_by_tag_id_and_song_id(@tag.id,
                                                                       @song.id)
    if @tag.errors.any?
      flash_message :error, "Tag could not be added!"
      redirect_to song_path(params[:tag][:song_id])
    else
      flash_message :success, "Tag \"#{@tag.name}\" saved!"
      redirect_to song_path(params[:tag][:song_id])
    end
  end
end
