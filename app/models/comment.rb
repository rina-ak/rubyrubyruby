class Comment < ApplicationRecord
  belongs_to :album
  belongs_to :user, optional: true
end
