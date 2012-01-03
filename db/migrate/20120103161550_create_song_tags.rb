class CreateSongTags < ActiveRecord::Migration
  def change
    create_table :song_tags do |t|
      t.integer :song_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :song_tags, :song_id
    add_index :song_tags, :tag_id
    add_index :song_tags, [:song_id, :tag_id], :unique => true
  end
end
