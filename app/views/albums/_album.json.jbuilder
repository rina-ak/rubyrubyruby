json.extract! album, :id, :title, :artist, :release_year, :duration, :release_type, :genre, :cover_url, :intro_text, :created_at, :updated_at
json.url album_url(album, format: :json)
