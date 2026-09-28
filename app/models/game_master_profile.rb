class GameMasterProfile < ApplicationRecord
  belongs_to :user
  has_many :games, dependent: :destroy
end
