class CreateAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :albums do |t|
      t.string :title
      t.string :artist
      t.integer :release_year
      t.string :duration
      t.string :release_type
      t.string :genre
      t.string :cover_url
      t.text :intro_text

      t.timestamps
    end
  end
end
