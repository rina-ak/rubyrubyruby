class AddCatalogFiltersToAlbums < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :mood, :string
    add_column :albums, :visual_language, :string
    add_column :albums, :cultural_context, :string
  end
end