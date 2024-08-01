class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|
      t.string :name, null:false
      t.date :dob, null:false
      t.string :gender, null:false
      t.text :address, null:false
      t.integer :first_release_year, null:false
      t.integer :no_of_albums_released, null:false

      t.timestamps
    end
  end
end
