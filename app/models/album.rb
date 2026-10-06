class Album < ApplicationRecord
  validates :title, :artist, presence: true

  has_many :thematic_sections, dependent: :destroy
  has_many :comments, dependent: :destroy
end