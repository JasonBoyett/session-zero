class PlayerProfile < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :player_notes, dependent: :destroy
end
