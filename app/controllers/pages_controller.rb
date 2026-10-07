class PagesController < ApplicationController
  def collections
    @genres = Album.pluck(:genre).compact.uniq
    @selected_genre = params[:genre]

    if @selected_genre.present?
      @albums = Album.where(genre: @selected_genre)
    else
      @albums = Album.all
    end
  end

  def about
  end
end