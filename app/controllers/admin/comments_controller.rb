module Admin
  class CommentsController < BaseController
    def index
      @comments = Comment.includes(:album, :user).order(created_at: :desc)
    end

    def destroy
      comment = Comment.find(params[:id])
      comment.destroy
      redirect_to admin_comments_path, notice: "Комментарий удалён."
    end
  end
end
