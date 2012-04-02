class AddScoreToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :score, :integer, :default => 0
  end
end
