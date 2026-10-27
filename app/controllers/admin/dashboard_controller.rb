module Admin
  class DashboardController < BaseController
    def show
      @proposals = AlbumProposal.order(created_at: :desc).limit(5)
      @counts = {
        proposals: AlbumProposal.count,
        albums: Album.count,
        comments: Comment.count,
        subscribers: Subscriber.count,
        users: User.count
      }
    end
  end
end
