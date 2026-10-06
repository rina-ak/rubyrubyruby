class AlbumsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "твой_пароль", only: [:new, :create]

  before_action :set_album, only: [:show]

  def index
    @albums = Album.all
  end

  def show
    @thematic_sections = @album.thematic_sections
    @comment = Comment.new
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to @album, notice: "Альбом успешно добавлен!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :artist, :release_year, :genre, :duration, :cover_url, :intro)
  end
end