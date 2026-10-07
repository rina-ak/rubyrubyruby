class CommentsController < ApplicationController
  before_action :set_album

 def create
  @comment = @album.comments.build(comment_params)
  @comment.user = current_user if user_signed_in?

  if @comment.save
    redirect_to @album, notice: "Комментарий успешно добавлен."
  else
    redirect_to @album, alert: "Не удалось добавить комментарий."
  end
end

  def destroy
    @comment = @album.comments.find(params[:id])
    @comment.destroy
    redirect_to @album, notice: "Комментарий удален."
  end

  private

  def set_album
    @album = Album.find(params[:album_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
