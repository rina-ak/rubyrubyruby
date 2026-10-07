class AddDurationAndReleaseTypeToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :albums, :duration, :string unless column_exists?(:albums, :duration)
    add_column :albums, :release_type, :string unless column_exists?(:albums, :release_type)
  end
end