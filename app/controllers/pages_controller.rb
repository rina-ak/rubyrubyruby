class PagesController < ApplicationController
  def collections
    @genres = Album.pluck(:genre).compact.uniq
    @albums = Album.all
  end

  def about
  end
end