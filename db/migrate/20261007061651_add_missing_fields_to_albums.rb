class AddMissingFieldsToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :albums, :description, :text unless column_exists?(:albums, :description)
    add_column :albums, :genre, :string unless column_exists?(:albums, :genre)
  end
end
