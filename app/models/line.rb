class Line < ApplicationRecord
  belongs_to :game
  belongs_to :player_profile
end
