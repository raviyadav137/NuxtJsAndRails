class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist_name
      t.string :album
      t.string :name
      t.string :genre
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
