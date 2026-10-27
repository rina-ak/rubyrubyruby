class DropReleaseYearFromAlbums < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE albums
      SET year = release_year
      WHERE year IS NULL AND release_year IS NOT NULL
    SQL
    remove_column :albums, :release_year
  end

  def down
    add_column :albums, :release_year, :integer
  end
end
