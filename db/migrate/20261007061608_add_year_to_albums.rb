class AddYearToAlbums < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :year, :integer
  end
end
