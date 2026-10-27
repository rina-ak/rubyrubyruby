module Admin
  class AlbumsController < BaseController
    def index
      @albums = Album.order(created_at: :desc)
    end
  end
end
