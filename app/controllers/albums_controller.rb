class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]

  def index
    @albums = Album.all
  end

  def show
  end

  def new
    @album = Album.new
  end

  def edit
  end

def create
  @album = Album.new(album_params)
  if @album.save
    redirect_to @album, notice: "Альбом успешно создан."
  else
    render :new, status: :unprocessable_entity
  end
end

  def update
    if @album.update(album_params)
      redirect_to @album, notice: "Альбом успешно обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_url, notice: "Альбом удален."
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :artist, :genre, :year, :description, :cover)
  end
end
