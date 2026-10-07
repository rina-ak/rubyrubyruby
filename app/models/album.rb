class Album < ApplicationRecord
  mount_uploader :cover, CoverUploader

  validates :title, :artist, presence: true

  has_many :thematic_sections, dependent: :destroy
  has_many :comments, dependent: :destroy
end
