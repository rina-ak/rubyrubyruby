module Admin
  class AlbumProposalsController < BaseController
    before_action :set_proposal, only: [:show, :destroy]

    def index
      @proposals = AlbumProposal.order(created_at: :desc)
    end

    def show
    end

    def destroy
      @proposal.destroy
      redirect_to admin_album_proposals_path, notice: "Заявка удалена."
    end

    private

    def set_proposal
      @proposal = AlbumProposal.find(params[:id])
    end
  end
end
