class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title, null:false
      t.string :artist_name, null:false
      t.string :album, null:false
      t.string :name, null:false
      t.string :genre, null:false
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
