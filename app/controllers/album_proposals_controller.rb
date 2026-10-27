class AlbumProposalsController < ApplicationController
  layout "album"

  def new
    @proposal = AlbumProposal.new
    authorize! :create, @proposal
  end

  def create
    @proposal = AlbumProposal.new(proposal_params)
    authorize! :create, @proposal
    if @proposal.save
      redirect_to root_path, notice: "Спасибо! Заявка принята."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def proposal_params
    params.require(:album_proposal).permit(:artist, :title, :notes)
  end
end
