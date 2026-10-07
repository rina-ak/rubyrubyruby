class AlbumProposalsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :require_admin!, only: [:index]

  def index
    @proposals = AlbumProposal.order(created_at: :desc)
  end

  def new
    @proposal = AlbumProposal.new
  end

  def create
    @proposal = AlbumProposal.new(proposal_params)
    if @proposal.save
      redirect_to root_path, notice: "Спасибо! Заявка принята."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    unless current_user&.admin
      redirect_to root_path, alert: "Доступ разрешен только администраторам."
    end
  end

  def proposal_params
    params.require(:album_proposal).permit(:artist, :title, :notes)
  end
end