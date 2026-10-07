class AddCoverToAlbums < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :cover, :string
  end
end
