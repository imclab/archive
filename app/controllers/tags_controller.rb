class TagsController < ApplicationController
  def index
    @title = "All tags"
    @tags = Tag.all_associated_with_songs
  end

  def show
    @tag = Tag.find(params[:id])
    @songs = @tag.songs
  end
end
