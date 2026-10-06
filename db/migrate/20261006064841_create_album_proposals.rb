class CreateAlbumProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :album_proposals do |t|
      t.string :artist
      t.string :title
      t.text :notes

      t.timestamps
    end
  end
end
