class AlbumsController < ApplicationController
  layout "album"
  before_action :authenticate_user!, except: %i[ index show search ]
  load_and_authorize_resource

  def index
    @albums = Album.all
  end

  def search
    @query = params[:q].to_s.strip
    @albums = Album.search(@query).order(:title)
  end

  def show
    render @album.dossier_template
  end

  def new
  end

  def edit
  end

  def create
    @album.assign_attributes(album_params)
    if @album.save
      redirect_to album_path(@album), notice: "Альбом успешно создан."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      redirect_to album_path(@album), notice: "Альбом успешно обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_url, notice: "Альбом удален."
  end

  private

  def album_params
    params.require(:album).permit(:title, :artist, :genre, :year, :description, :intro_text, :duration, :release_type, :cover, :cover_url, :mood, :visual_language, :cultural_context)
  end
end
