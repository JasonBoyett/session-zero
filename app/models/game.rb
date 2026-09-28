class Game < ApplicationRecord
  belongs_to :game_master_profile

  has_many :player_profiles, dependent: :destroy
  has_many :game_master_notes, dependent: :destroy
  has_many :lines, dependent: :destroy
  has_many :veils, dependent: :destroy
end
