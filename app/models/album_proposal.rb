class AlbumProposal < ApplicationRecord
  validates :artist, :title, presence: true
end
