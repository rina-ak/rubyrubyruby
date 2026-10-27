class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album

  def create
    @comment = @album.comments.build(comment_params)
    @comment.user = current_user
    authorize! :create, @comment

    if @comment.save
      redirect_to album_path(@album, anchor: "discussion"), notice: "Комментарий добавлен."
    else
      redirect_to album_path(@album, anchor: "discussion"), alert: "Не удалось добавить комментарий."
    end
  end

  def destroy
    @comment = @album.comments.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    redirect_to album_path(@album, anchor: "discussion"), notice: "Комментарий удалён."
  end

  private

  def set_album
    @album = Album.find(params[:album_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
